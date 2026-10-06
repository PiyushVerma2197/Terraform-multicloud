variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "azure_location" {
  description = "Azure region"
  type        = string
}

variable "aws_availability_zones" {
  type = list(string)
}

variable "route53_domain" {
  description = "Domain already purchased from an external registrar"
  type        = string
}

variable "petclinic_subdomain" {
  description = "Subdomain for PetClinic"
  type        = string
  default     = "petclinic"
}

