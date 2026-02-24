terraform {
    backend "azurerm" {
        resource_group_name  = "rg-empath-tfstate"
        storage_account_name = "tfstateprod123"
        container_name       = "state"
        key                  = "dev.tfstate."
    }
}