terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = ">= 2.13"
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "sample-tf-state"
  acl    = "private"

  region = var.region
  tags = {
    Name        = "Module Sample"
    Environment = "Develop"
  }
}
