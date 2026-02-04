# Azure Infrastructure-as-Code: Modular Storage Deployment

## 📋 Project Overview
This project demonstrates a transition from manual infrastructure management to **DevOps best practices** using Terraform. It provides a reusable, standardized module for deploying Azure Storage Accounts and Resource Groups across multiple environments (Dev, QA, Prod).

By using this modular approach, we eliminate "configuration drift" and ensure that infrastructure is version-controlled, predictable, and scalable.

## 🚀 Key Features
* **Modular Architecture:** Dry (Don't Repeat Yourself) code structure using child modules.
* **Variable Injection:** Dynamic naming and region selection via `variables.tf`.
* **Implicit Dependencies:** Automated resource sequencing (Terraform handles the creation order).
* **Cloud Agnostic Workflow:** Standardized `init`/`plan`/`apply` workflow compatible with Azure Cloud Shell.

## 🛠️ Tech Stack
* **Terraform CLI** (v1.x+)
* **Azure Provider** (azurerm)
* **HashiCorp Configuration Language (HCL)**

## 📂 Repository Structure
```text
.
├── main.tf                # Root module: Calls the child modules
├── variables.tf           # Input variables for the root
├── modules/
│   └── storage-account/
│       ├── main.tf        # Module logic
│       ├── variables.tf   # Module inputs
│       └── outputs.tf     # Module outputs
└── README.md
