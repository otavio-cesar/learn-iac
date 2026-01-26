provider "aws" {
  region = "us-east-1"
   
   assume_role {
    role_arn     = "arn:aws:iam::045444243386:role/terra"
  }
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name = "name"
#     values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
#   }

#   owners = ["099720109477"] # Canonical
# }

resource "aws_instance" "app_server" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  key_name = "par-chaves"
  # user_data = <<-EOF
  #                 #!/bin/bash
  #                       cd /home/ubuntu
  #                       echo "<h1>Feito com Terraform</h1>" > index.html
  #                       nohup busybox httpd -f -p 8080 &
  #                 EOF
  tags = {
    Name = "learn-terraform"
  }
}

resource "aws_key_pair" "chaveSSH" {
  key_name   = DEV
  public_key = file("IaC-DEV.pub")
  
}


