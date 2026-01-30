terraform {
  backend "s3" {
    bucket = "amzn-s3-terraform-iac"
    key    = "Prod/terraform.tfstate"
    region = "us-east-1"
  }
}
