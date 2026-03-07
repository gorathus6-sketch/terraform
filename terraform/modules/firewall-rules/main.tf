resource "azure_firewall_policy_rule_collection_group" "this" {
    name              = var.name
    firewall_policy_id = var.firewall_policy_id
    priority = var.priority

    application_rule_collection {
        name     = "appRules"
        priority = 100
        action   = "Allow"
    
        rule {
            name = "AllowHTTPS"
            source_addresses = ["*"]
            destination_fqdns = ["microsoft.com"]
            protocols {
                port = 443
                type = "Https"
            }
        }
    }

    network_rule_collection {
        name     = "netRules"
        priority = 200
        action   = "Allow"

        rule {
            name                  = "AllowDNS"
            source_addresses      = ["*"]
            destination_addresses = ["*"]
            destination_ports     = ["53"]
            protocols             = ["UDP"]
        }
    }
}
