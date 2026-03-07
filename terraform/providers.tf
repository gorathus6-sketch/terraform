terraform {
    required_version = ">= 1.6.0"

    backend "azurerm" {
        resource_group_name  = "tfstate-rg-dev"
        storage_account_name = "tfstatestorageempathdev"
        container_name       = "tfstate"
        key                  = "dev.terrform.tfstate"
    }
}

provider "azurerm" {
    features {}
    tenant_id       = var.tenant_id
    subscription_id = var.subscription_id
}
