variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the Azure Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the Azure Subnet"
  type        = string
}

variable "public_ip_name" {
  description = "Name of the Azure Public IP"
  type        = string
}

variable "nsg_name" {
  description = "Name of the Azure Network Security Group"
  type        = string
}

variable "nsg_rule_name" {
  description = "Name of the NSG rule"
  type        = string
}

variable "destination_port_range" {
  description = "Destination port range for the NSG rule"
  type        = string
  default     = "22"
}

variable "network_interface_name" {
  description = "Name of the Azure Network Interface"
  type        = string
}

variable "ip_configuration_name" {
  description = "Name of the Azure IP Configuration"
  type        = string
}

variable "vm_name" {
  description = "Name of the Azure Virtual Machine"
  type        = string
}

variable "vm_size" {
  description = "Size of the Azure Virtual Machine"
  type        = string
}

variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
}

variable "os_disk_name" {
  description = "Name of the OS disk"
  type        = string
}

variable "os_disk_type" {
  description = "Type of the OS disk"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM"
  type        = string
}
