variable "resource_group_name" {
  default = "terraform-infra-rg"
}

variable "location" {
  default = "eastus"
}

variable "vnet_name" {
  default = "tf-secure-vnet"
}

variable "subnet_name" {
  default = "tf-default-subnet"
}

variable "nsg_name" {
  default = "tf-secure-nsg"
}

variable "vm_name" {
  default = "tf-secure-vm"
}

variable "admin_username" {
  default = "azureuser"
}

variable "keyvault_name" {
  default = "tf-kv-brayden"
}

variable "allowed_ssh_ip" {
  description = "Your public IP address for SSH access"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}
