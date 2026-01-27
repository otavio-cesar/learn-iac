provider "aws" {
  region = var.regiao_aws
   assume_role {
    role_arn     = "arn:aws:iam::045444243386:role/terra"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = var.instancia
  key_name = var.chave
  tags = {
    Name = "learn-terraform"
  }
}

resource "aws_key_pair" "chaveSSH" {
  key_name   = var.chave
  public_key = file("${var.chave}.pub")
  
}


