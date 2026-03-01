                          +--------------------------------------+
                          |        EMPATH Learning Center        |
                          |   Cloud • SecOps • Automation Lab    |
                          +------------------+-------------------+
                                             |
                                             |
                           +-----------------v-----------------+
                           |            Azure Cloud            |
                           +-----------------------------------+
                           | Resource Groups (RG-Empath-DEV)   |
                           | Virtual Networks (vnet-empath)    |
                           | Subnets (app, db, mgmt)           |
                           | Network Security Groups (NSGs)    |
                           | Route Tables                      |
                           +-----------------+-----------------+
                                             |
                                             |
        +-------------------------+----------+----------+--------------------------+
        |                         |                     |                          |
        |                         |                     |                          |
+-------v-------+       +---------v--------+   +--------v---------+       +--------v--------+
| Virtual       |       | Kubernetes       |   | Wazuh SIEM       |       | Grafana          |
| Machines      |       | Cluster (K8s)    |   | (Agents + Server)|       | Dashboards       |
| (Linux/Win)   |       | Workloads        |   | Security Events  |       | Metrics & Logs   |
+---------------+       +------------------+   +------------------+       +------------------+
        |                         |                     |                          |
        +-------------------------+----------+----------+--------------------------+
                                             |
                                             |
                           +-----------------v-----------------+
                           |         Hybrid Networking         |
                           +-----------------------------------+
                           | Cisco IOS Switches/Routers        |
                           | VLANs, ACLs, Routing              |
                           | On-Prem ↔ Azure Connectivity      |
                           +-----------------+-----------------+
                                             |
                                             |
                           +-----------------v-----------------+
                           |     CI/CD Automation (GitHub)     |
                           +-----------------------------------+
                           | terraform-ci.yml (PR validation)  |
                           | terraform-apply.yml (deploy)      |
                           | terraform-destroy.yml (cleanup)   |
                           | OIDC → Azure secure auth          |
                           +-----------------------------------+
