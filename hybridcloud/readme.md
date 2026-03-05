# Hybrid Cloud Lab: Azure + Bicep + AD DS + VMware + Hybrid Identity

This project demonstrates the ability to provision Azure infrastructure using Bicep/ARM, operate an on-prem Active Directory Domain Services environment, manage VMware vSphere/ESXi virtualization, and integrate hybrid identity using Entra Connect.

## 🔧 Technologies Used
- Azure Resource Manager (ARM)
- Bicep IaC
- Azure CLI
- GitHub Actions
- Active Directory Domain Services (AD DS)
- VMware vSphere / ESXi
- Entra ID + Entra Connect

## 📁 Repository Structure
- `/bicep` — Modular IaC for Azure (network, compute, storage)
- `/ad-ds` — Domain controller build, GPOs, troubleshooting
- `/vmware` — vSphere operations, vMotion, HA/DRS notes
- `/hybrid-identity` — Entra Connect setup and sync rules
- `/docs` — Architecture diagrams and lab documentation

## 🚀 Azure Deployment
The `main.bicep` file deploys:
- Resource group
- Virtual network + subnets
- Network security groups
- Virtual machine
- Storage account

Deployment command:
```bash
az deployment sub create \
  --location eastus \
  --template-file main.bicep \
  --parameters main.parameters.json
