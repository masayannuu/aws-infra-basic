# Main Setting
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = ">= 2.13"
  }

  backend "s3" {
    bucket  = "sample-tf-state" # bucket定義する
    region  = "ap-northeast-1"
    profile = "masayannuu"
    key     = "develop.tfstate"
    encrypt = true
  }
}

# Provider Settings
provider "aws" {
  region  = var.region
  profile = var.profile
}

# AWS Resources
## VPC
module "vpc" {
  source = "../../"

  name = "module develop sample vpc"

  cidr = "10.0.0.0/16"

  azs              = ["${var.region}a", "${var.region}c", "${var.region}d"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.11.0/24", "10.0.12.0/24"] # fargate, aurora
  database_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  create_database_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_classiclink             = false
  enable_classiclink_dns_support = false

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "Develop"
    Name        = "Module Sample"
  }
}

## Security Group
module "public_subnet_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "public-subnet-sg"
  description = "Security group which is used as an argument in complete-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["10.10.0.0/16"]
  ingress_rules       = ["https-443-tcp"]
}
