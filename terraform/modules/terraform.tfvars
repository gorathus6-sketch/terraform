tenant_id = "TENANT-A-GUID"
subscription_id = SUBSCRIPTION-A-GUID"

resource_group_name = "RG-Empath-DEV"
location            = "eastus"

tags = {
    environment = "dev"
    department  = "education"
}

vnet_name     = "vnet-empath-dev"
address_space = ["10.10.0.0/16"]

subnets = {
    web = {
        address_prefixes = ["10.10.1.0/24"]
    }
    db = {
        address_prefixes = ["10.10.2.0/24"]
    }
}

web_nsg_rules = [
    {
        name                       = "Allow-HTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    },
    {
        name                       = "Allow-HTTPS"
        priority                   = 110
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
    }
]

db_nsg_rules = [
    {
        name                       = "Allow-Web-To-DB"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "10.10.1.10/24"
        destination_address_prefix = "*"
    }
]

keyvault_name     = "kv-empath-dev-dev"
loganalytics_name = "law-empath-dev"

admin_object_ids  = ["ADMIN-OBJECT-ID-1"]
non_admin_object_ids = ["NONADMIN-OBJECT-ID-1"]

log_categories = ["AuditEvent", "AzureDiagnostics"]
metric_categories = ["AllMetrics"]
