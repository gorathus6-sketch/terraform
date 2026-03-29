terraform {
    cloud {
        organization = "empathome-gorat"
        workspaces {
            name = "empath-dev"
        }
    }
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}
