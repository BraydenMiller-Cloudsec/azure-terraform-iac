# Azure Infrastructure as Code — Terraform + GitHub Actions CI/CD

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat&logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0089D6?style=flat&logo=microsoft-azure&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat&logo=github-actions&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-success)

## Overview

A complete Azure infrastructure deployment using Terraform as infrastructure as code with a GitHub Actions CI/CD pipeline for automated deployment. This project takes the manually built infrastructure from previous projects and redeploys it entirely from code — demonstrating that the entire secure environment can be destroyed and recreated identically in minutes from a single git push.

## Technologies Used

- Terraform (HCL)
- Microsoft Azure
- GitHub Actions CI/CD
- Azure Blob Storage (Terraform remote state)
- Azure Virtual Network + Subnets
- Azure Virtual Machines (Ubuntu 22.04)
- Network Security Groups
- Azure Key Vault
- Role-Based Access Control (RBAC)
- Managed Identities
- Azure Service Principal

  ## Architecture

```
GitHub Repository (azure-terraform-iac)
│
├── Terraform Configuration Files
│     ├── main.tf — Provider config and remote state backend
│     ├── variables.tf — Input variable definitions
│     ├── networking.tf — Resource group, VNet, subnet, NSG
│     ├── vm.tf — Public IP, NIC, Linux VM with managed identity
│     ├── keyvault.tf — Key Vault, RBAC assignments, secrets
│     └── outputs.tf — VM IP, Key Vault URI, identity outputs
│
├── GitHub Actions Pipeline (.github/workflows/terraform.yml)
│     ├── Trigger: push to main branch
│     ├── Step 1: Checkout code
│     ├── Step 2: Setup Terraform
│     ├── Step 3: Azure Login (service principal)
│     ├── Step 4: Terraform Init
│     ├── Step 5: Terraform Format Check
│     ├── Step 6: Terraform Validate
│     ├── Step 7: Terraform Plan
│     └── Step 8: Terraform Apply (main branch only)
│
└── Deployed Azure Infrastructure
      ├── Resource Group (terraform-infra-rg)
      ├── Virtual Network (tf-secure-vnet) 10.0.0.0/16
      │     └── Subnet (tf-default-subnet) 10.0.1.0/24
      │           └── NSG — SSH restricted to admin IP only
      ├── Virtual Machine (tf-secure-vm)
      │     ├── Ubuntu 22.04 LTS
      │     └── System-assigned managed identity
      └── Key Vault (tf-kv-brayden)
            ├── RBAC authorization enabled
            ├── Key Vault Administrator — admin user
            └── Key Vault Secrets User — VM managed identity
```
## Implementation Details

### Step 1 — Terraform Configuration
Wrote six Terraform HCL configuration files defining the complete Azure infrastructure. Used variables throughout to make the configuration reusable — SSH IP, VM name, Key Vault name, and SSH public key are all parameterized so the same code can deploy to any environment by changing variable values.

**Key decision:** Separated configuration into logical files by concern — networking, compute, and security are each in their own file. This mirrors real enterprise Terraform codebases where large infrastructures are organized into modules.

### Step 2 — Remote State Backend
Configured Terraform remote state stored in Azure Blob Storage. State is shared between local development and the GitHub Actions pipeline ensuring both environments see the same infrastructure state and preventing conflicting deployments.

**Key decision:** Remote state is non-negotiable for any team or CI/CD workflow — without it two simultaneous deployments could corrupt the state file and cause infrastructure drift.

### Step 3 — Service Principal Authentication
Created a dedicated Azure service principal with Contributor and User Access Administrator roles for GitHub Actions to authenticate to Azure. Stored all credentials as encrypted GitHub secrets — never hardcoded in any file.

**Key decision:** Used a dedicated service principal rather than personal credentials — follows least privilege and means the CI/CD pipeline has its own auditable identity separate from any human user.

### Step 4 — GitHub Actions CI/CD Pipeline
Built a GitHub Actions workflow that triggers automatically on every push to the main branch. The pipeline runs terraform fmt, validate, plan, and apply in sequence — ensuring code quality checks run before any infrastructure changes are made.

**Key decision:** Apply only runs on pushes to main, not on pull requests — pull requests only run plan so you can review changes before they deploy. This mirrors real enterprise GitOps workflows.

### Step 5 — End to End Verification
Verified the complete pipeline by pushing code to GitHub, watching GitHub Actions deploy all resources automatically, and confirming all 7 Azure resources deployed successfully. The entire secure infrastructure — networking, compute, identity, and secrets management — deployed from a single git push with zero manual intervention.

**Key decision:** Infrastructure as code means the environment is reproducible — delete everything and run the pipeline again to get an identical environment. This eliminates configuration drift and makes disaster recovery trivial.

## Repository Structure

The repository contains the following files:

- `.github/workflows/terraform.yml` — GitHub Actions CI/CD pipeline
- `main.tf` — Provider configuration and remote state backend
- `variables.tf` — Input variable definitions
- `networking.tf` — Resource group, VNet, subnet, NSG
- `vm.tf` — Public IP, network interface, Linux VM
- `keyvault.tf` — Key Vault, RBAC assignments, secrets
- `outputs.tf` — Output values displayed after deployment
- `.gitignore` — Excludes state files and provider binaries

## GitHub Secrets Required

| Secret | Description |
|---|---|
| `AZURE_CREDENTIALS` | Service principal credentials JSON |
| `ALLOWED_SSH_IP` | Your public IP for SSH NSG rule |
| `SSH_PUBLIC_KEY` | SSH public key for VM access |
| `AZURE_STORAGE_KEY` | Storage account key for remote state |

## Usage

To deploy this infrastructure in your own environment:

1. Fork this repository
2. Create an Azure service principal with Contributor and User Access Administrator roles
3. Add the required GitHub secrets listed above
4. Push to main branch — GitHub Actions will deploy automatically

## Lessons Learned

- Terraform state management is critical — remote state in Azure Blob Storage enables both local and CI/CD pipeline deployments to share the same state
- Service principals need both Contributor and User Access Administrator roles to create RBAC assignments — Contributor alone is insufficient
- Cloud Shell is ephemeral — SSH keys and files are wiped on session reset, making remote state and parameterized variables essential
- Infrastructure as code eliminates configuration drift — the deployed environment always matches what is defined in code
- GitHub Actions secrets keep sensitive values out of public repositories — subscription IDs, credentials, and IP addresses never appear in code
- Terraform import allows existing manually-created resources to be brought under Terraform management without recreation

## What I Would Add in Production

- **Terraform modules** — refactor into reusable modules for networking, compute, and security that can be called across multiple environments
- **Multiple environments** — separate workspaces or state files for dev, staging, and production with environment-specific variable files
- **Pull request workflow** — require plan review and approval before merging to main, preventing unreviewed infrastructure changes
- **Drift detection** — scheduled pipeline runs that detect when manual changes have been made outside of Terraform
- **Policy as code** — integrate Azure Policy or Sentinel policies into the pipeline using the AzureRM provider
- **Cost estimation** — integrate Infracost to show cost impact of infrastructure changes in pull request comments
- **Terraform Cloud** — migrate from Azure Blob state to Terraform Cloud for better state management, run history, and team collaboration

## Author

**Brayden Miller**
[LinkedIn](https://www.linkedin.com/in/brayden-miller13/) | [GitHub](https://github.com/BraydenMiller-CloudSec)

---
*Built as part of a hands-on Azure cloud security portfolio. See my other projects on GitHub.*
