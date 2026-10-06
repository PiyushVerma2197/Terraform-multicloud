variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vnet_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "app_gateway_subnet_cidr" {
  type = string
}

variable "aks_kubernetes_version" {
  type = string
}

variable "aks_node_vm_size" {
  type = string
}

variable "aks_node_count" {
  type = number
}