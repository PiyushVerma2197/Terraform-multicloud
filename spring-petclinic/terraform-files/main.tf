locals {

  # Current Terraform Workspace
  environment = terraform.workspace

  # AWS VPC CIDRs

  aws_vpc_cidrs = {

    dev   = "10.10.0.0/16"
    stage = "10.30.0.0/16"
    prod  = "10.50.0.0/16"
  }

  aws_public_subnet_cidrs = {

    dev = [
      "10.10.1.0/24",
      "10.10.2.0/24"
    ]

    stage = [
      "10.30.1.0/24",
      "10.30.2.0/24"
    ]

    prod = [
      "10.50.1.0/24",
      "10.50.2.0/24"
    ]
  }

  aws_private_subnet_cidrs = {

    dev = [
      "10.10.11.0/24",
      "10.10.12.0/24"
    ]

    stage = [
      "10.30.11.0/24",
      "10.30.12.0/24"
    ]

    prod = [
      "10.50.11.0/24",
      "10.50.12.0/24"
    ]
  }

  rds_database_names = {
    dev   = "appdb"
    stage = "appdb"
    prod  = "appdb"
  }

  rds_usernames = {
    dev   = "appuser"
    stage = "appuser"
    prod  = "appuser"
  }

  rds_instance_classes = {
    dev   = "db.t3.micro"
    stage = "db.t3.small"
    prod  = "db.t3.medium"
  }

  rds_allocated_storages = {
    dev   = 20
    stage = 30
    prod  = 50
  }

  # Azure VNet CIDRs

  azure_vnet_cidrs = {

    dev   = "10.20.0.0/16"
    stage = "10.40.0.0/16"
    prod  = "10.60.0.0/16"
  }

  azure_public_subnet_cidrs = {

    dev = [
      "10.20.1.0/24",
      "10.20.2.0/24"
    ]

    stage = [
      "10.40.1.0/24",
      "10.40.2.0/24"
    ]

    prod = [
      "10.60.1.0/24",
      "10.60.2.0/24"
    ]
  }

  azure_private_subnet_cidrs = {

    dev = [
      "10.20.11.0/24",
      "10.20.12.0/24"
    ]

    stage = [
      "10.40.11.0/24",
      "10.40.12.0/24"
    ]

    prod = [
      "10.60.11.0/24",
      "10.60.12.0/24"
    ]
  }
  azure_app_gateway_subnet_cidrs = {

    dev   = "10.20.21.0/24"
    stage = "10.40.21.0/24"
    prod  = "10.60.21.0/24"

  }
  eks_cluster_names = {
    dev   = "dev-eks"
    stage = "stage-eks"
    prod  = "prod-eks"
  }

  eks_kubernetes_versions = {
    dev   = "1.31"
    stage = "1.31"
    prod  = "1.31"
  }

  eks_node_instance_types = {
    dev   = "t3.small"
    stage = "t3.medium"
    prod  = "t3.large"
  }

  eks_node_min_sizes = {
    dev   = 1
    stage = 2
    prod  = 3
  }

  eks_node_max_sizes = {
    dev   = 2
    stage = 4
    prod  = 6
  }

  eks_node_desired_sizes = {
    dev   = 1
    stage = 2
    prod  = 3
  }


  aks_kubernetes_versions = {
    dev   = "1.31"
    stage = "1.31"
    prod  = "1.31"
  }

  aks_node_vm_sizes = {
    dev   = "Standard_B2s"
    stage = "Standard_D2s_v5"
    prod  = "Standard_D4s_v5"
  }

  aks_node_counts = {
    dev   = 1
    stage = 2
    prod  = 3
  }
}

# AWS VPC MODULE

module "aws_vpc" {

  source                 = "./modules/aws-resources"
  environment            = local.environment
  vpc_name               = "${local.environment}-aws-vpc"
  vpc_cidr               = local.aws_vpc_cidrs[local.environment]
  public_subnet_cidrs    = local.aws_public_subnet_cidrs[local.environment]
  private_subnet_cidrs   = local.aws_private_subnet_cidrs[local.environment]
  availability_zones     = var.aws_availability_zones
  eks_cluster_name       = local.eks_cluster_names[local.environment]
  eks_kubernetes_version = local.eks_kubernetes_versions[local.environment]
  eks_node_instance_type = local.eks_node_instance_types[local.environment]
  eks_node_min_size      = local.eks_node_min_sizes[local.environment]
  eks_node_max_size      = local.eks_node_max_sizes[local.environment]
  eks_node_desired_size  = local.eks_node_desired_sizes[local.environment]
  rds_database_name      = local.rds_database_names[local.environment]
  rds_username           = local.rds_usernames[local.environment]
  # rds_password           = local.rds_password[local.environment]
  rds_instance_class    = local.rds_instance_classes[local.environment]
  rds_allocated_storage = local.rds_allocated_storages[local.environment]
  domain_name           = var.route53_domain
  subdomain             = var.petclinic_subdomain
  alb_dns_name          = module.aws_vpc.alb_dns_name
  alb_zone_id           = module.aws_vpc.alb_zone_id
}

# AZURE VNET MODULE

module "azure_vnet" {

  source                  = "./modules/azure-resources"
  environment             = local.environment
  resource_group_name     = "${local.environment}-network-rg"
  location                = var.azure_location
  vnet_name               = "${local.environment}-azure-vnet"
  vnet_cidr               = local.azure_vnet_cidrs[local.environment]
  public_subnet_cidrs     = local.azure_public_subnet_cidrs[local.environment]
  private_subnet_cidrs    = local.azure_private_subnet_cidrs[local.environment]
  app_gateway_subnet_cidr = local.azure_app_gateway_subnet_cidrs[local.environment]
  aks_kubernetes_version  = local.aks_kubernetes_versions[local.environment]
  aks_node_vm_size        = local.aks_node_vm_sizes[local.environment]
  aks_node_count          = local.aks_node_counts[local.environment]
}

