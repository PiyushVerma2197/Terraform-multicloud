output "environment" {
  value = terraform.workspace
}

output "aws_vpc_id" {
  value = module.aws_vpc.vpc_id
}

output "aws_vpc_cidr" {
  value = module.aws_vpc.vpc_cidr
}

output "azure_resource_group" {
  value = module.azure_vnet.resource_group_name
}

output "azure_vnet_id" {
  value = module.azure_vnet.vnet_id
}

output "azure_vnet_cidr" {
  value = module.azure_vnet.vnet_cidr
}

output "rds_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.aws_vpc.rds_endpoint
}

output "rds_port" {
  description = "RDS PostgreSQL port"
  value       = module.aws_vpc.rds_port
}

output "rds_database_name" {
  description = "RDS PostgreSQL database name"
  value       = module.aws_vpc.rds_database_name
}

output "rds_master_user_secret_arn" {
  value = module.aws_vpc.rds_master_user_secret_arn
}