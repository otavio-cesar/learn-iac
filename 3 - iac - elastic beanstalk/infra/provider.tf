terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = var.regiao_aws
  assume_role {
    role_arn = "arn:aws:iam::045444243386:role/terra"
  }
}