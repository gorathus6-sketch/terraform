# Prerequisites:
# Python 3.9+
# pip install azure-identity azure-mgmt-network
# Environment variables set for service principal
# or managed identity:
# - AZURE_TENANT_ID
# - AZURE_CLIENT_ID
# - AZURE_CLIENT_SECRET
# Your subscription ID (hardcoded or env variable)

import os
from typing import List, Dict

from azure.identity import DefaultAzureCredential
from azure.mgmt.network import NetworkManagementClient

#
# Configuraiton
#

# Subscription to scan

SUBSCRIPTION_ID = os.environ.get("AZURE_SUBSCRIPTION_ID", "<YOUR_SUBSCRIPTION_ID>")

# Typically vulnerable ports

SENSITIVE_PORTS = {
    22: "SSH",
    3389: "RDP",
    1433: "SQL Server",
    3306: "MySQL",
    5432: "PostreSQL",
    80: "HTTP",
    443: "HTTPS",
}

# CIDR considered anywhere

INTERNET_CIDRS = {"0.0.0.0/0", "*", "Internet"}

#
# Core Logic
#

def get_network_client() -> NetworkManagementClient:
    credential = DefaultAzureCredential()
    return NetworkManagementClient(credential, SUBSCRIPTION_ID)

def is_internet_exposed(source_prefix: str, source_prefixes: List[str]) -> bool:
    """
    Returns True if the rule allows traffic from the public Internet.
    """
    # Single prefix

    if source_prefix and source_prefix in INTERNET_CIDRS:
        return True
    
    # Multiple prefixes

    if source_prefixes:
        for p in source_prefixes:
            if p in INTERNET_CIDRS:
                return True
            
    return False

def get_ports_from_rule(rule) -> List[int]:
    """
    Extracts destination ports from a rule.
    Handles single port, range, or '*".
    """
    ports = []

    # Azure NSG rules can specify:
    # - destination_port_range (string)
    # - destination_port_ranges (list of strings)
    # - '*' for all ports

    raw_ports = []

    if rule.destination_port_range:
        raw_ports.append(rule.destination_port_range)

    if rule.destination_port_ranges:
        raw_ports.extend(rule.destination_port_ranges)
    
    for rp in raw_ports:
        if rp == "*" or rp is None:
            # all ports, we treat as "all" and let caller decide

            continue
        
        if "-" in rp:
            # port range like "1000-2000"

            start, end = rp.split("-", 1)
            try:
                start = int(start)
                end = int(end)
                ports.extend(range(start, end + 1))
            except ValueError:
                continue
        else:
            try:
                ports.append(int(rp))
            except ValueError:
                continue
            
    return ports

def analyze_nsg_rules(network_client: NetworkManagementClient) -> List[Dict]:
    """
    Returns a list of finds for risky NSG rules.
    """
    findings = []

    for nsg in network_client.network_security_groups.list_all():
        nsg_name = nsg.name
        nsg_id = nsg.id
        resource_group = nsg_id.split("/")[4] if nsg_id else "unknown-rg"

        security_rules = nsg.security_rules or []

        for rule in security_rules:
            # Only care about inbound allow rules

            if rule.access != "Allow" or rule.direction != "Inbound":
                continue
            
            if not is_internet_exposed(
                rule.source_address_prefix,
                rule.source_address_prefixes,
            ):
                continue
            
            ports = get_ports_from_rule(rule)
            sensitive_hit = [p for p in ports if p in SENSITIVE_PORTS]

            # if rule alls all ports from Internet, treat as high risk

            allows_all_ports = (
                (rule.destination_port_range == "*" or not ports)
                and not rule.destination_port_ranges
            )

            if not sensitive_hit and not allow_all_ports:
                # not touching any of our sensitive ports and not all ports

                continue
            
            findings.append(
                {
                    "resource_group": resource_group,
                    "nsg_name": nsg_name,
                    "rule_name": rule.name,
                    "priority": rule.priority,
                    "protocol": rule.protocol,
                    "source": rule.source_address_prefix
                    or rule.source_address_prefixes,
                    "destination_ports": (
                        "ALL" if allows_all_ports else sorted(set(ports))
                    ),
                    "sensitive_ports": sorted(set(sensitive_hit)),
                    "description": rule.description,
                }
            )

    return findings

def print_report(findings: List[Dict]) -> None:
    if not findings:
        print("No risky NSG rules exposing sensitive ports to the Internet found")
        return
    
    print("\n Risky NSG rules detected:\n")
    for f in sorted(findings, key=lambda x: (x["resource_group"], x["nsg_name"], x["priority"])):
        print(f"Resource Group : {f['resource_group']}")
        print(f"NSG            : {f['nsg_name']}")
        print(f"Rule           : {f['rule_name']} (Priority {f['priority']})")
        print(f"Protocol       : {f['protocol']}")
        print(f"Source         : {f['source']}")
        print(f"Dest Ports     : {f['destination_ports']}")
        if f["senstivie_ports"]:
            labels = [f"{p} ({SENSITIVE_PORTS[p]})" for p in f["sensitive_ports"]]
            print(f"Senstivie Hit  : {', '.join(labels)}")
        print(f"Description    : {f['description']}\n")
        print("-" * 60)

    print(f"\nTotal risky rules found: {len(findings)}")

def main():
    if SUBSCRIPTION_ID.startswith("<") or not SUBSCRIPTION_ID:
        raise SystemExit("Please set AZURE_SUBSCRIPTION_ID or hardcode your subscription ID.")
    
    client = get_network_client()
    findings = analyze_nsg_rules(client)
    print_report(findings)

if __name__ == "__main__":
    main()