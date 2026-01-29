provider "aws" {
  region = var.regiao_aws
   assume_role {
    role_arn     = "arn:aws:iam::045444243386:role/terra"
  }
}

resource "aws_launch_template" "maquina" {
  image_id = "ami-0b6c6ebed2801a5cb"
  instance_type = var.instancia
  key_name = var.chave
  tags = {
    Name = "Terraform Ansible Python"
  }
  security_group_names = [var.grupo_seguranca]
}
# In case we want to create a instance using launch template
# resource "aws_instance" "instancia_com_template"{
#     launch_template {
#       id = aws_launch_template.maquina.id
#       version = "$Latest"
#     }
# }

resource "aws_key_pair" "chaveSSH-AutoScaling" {
  key_name   = var.chave
  public_key = file("${var.chave}.pub")
}

resource "aws_autoscaling_group" "grupo" {
  availability_zones = ["${var.regiao_aws}a"]
  name = var.nomeGrupo
  min_size = var.minimo
  max_size = var.maximo
  launch_template {
    id = aws_launch_template.maquina.id
    version = "$Latest"
  }
}