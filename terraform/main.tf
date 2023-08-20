terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket  = "mirza-terraform-state-backend"
    key     = "state.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}

locals {
  environment = terraform.workspace
}

provider "aws" {
  region = var.aws_region
}

module "web-application" {
  count = contains(["dev", "stage", "prod"], local.environment) ? 1 : 0

  source          = "../web-module"
  ami             = var.ami
  ssh_key         = var.ssh_key
  aws_region      = var.aws_region
  instance_type   = var.instance_type
  app_bucket_name = var.app_bucket_name
}