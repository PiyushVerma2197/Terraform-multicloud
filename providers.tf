terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
    backend "s3" {
      bucket         = "terraform-bucket-mumbai-12"
      key            = "envs/dev/terraform.tfstate"
      region         = "ap-south-1"
      encrypt        = true
  
  }
}

provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
}

