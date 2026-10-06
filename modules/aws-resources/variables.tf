variable "vpc_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "eks_cluster_name" {
  type = string
}

variable "eks_kubernetes_version" {
  type = string
}

variable "eks_node_instance_type" {
  type = string
}

variable "eks_node_min_size" {
  type = number
}

variable "eks_node_max_size" {
  type = number
}

variable "eks_node_desired_size" {
  type = number
}

variable "rds_database_name" {
  type = string
}

variable "rds_username" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "rds_allocated_storage" {
  type = number
}

variable "domain_name" {
  description = "Root domain"
  type        = string
}

variable "subdomain" {
  description = "Application subdomain"
  type        = string
  default     = "petclinic"
}

variable "alb_dns_name" {
  description = "Existing ALB DNS name"
  type        = string
}

variable "alb_zone_id" {
  description = "Existing ALB hosted zone ID"
  type        = string
}

