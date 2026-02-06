terraform {
  backend "s3" {
    bucket = "amzn-s3-terraform-iac-ecs"
    key    = "Dev/terraform.tfstate"
    region = "us-east-1"
  }
}
