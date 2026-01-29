provider "aws" {
  region = var.regiao_aws
  assume_role {
    role_arn = "arn:aws:iam::045444243386:role/terra"
  }
}

resource "aws_launch_template" "maquina" {
  image_id      = "ami-0b6c6ebed2801a5cb"
  instance_type = var.instancia
  key_name      = var.chave
  tags = {
    Name = "Terraform Ansible Python"
  }
  security_group_names = [var.grupo_seguranca]
  user_data            = filebase64("ansible.sh")
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
  availability_zones = ["${var.regiao_aws}a", "${var.regiao_aws}b"]
  name               = var.nomeGrupo
  min_size           = var.minimo
  max_size           = var.maximo
  launch_template {
    id      = aws_launch_template.maquina.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.target-group.arn]
}

# Daqui para baixo vem a configuracao do autoscaling com o loadbalancer
resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.regiao_aws}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.regiao_aws}b"
}

resource "aws_lb" "load-balancer" {
  internal = false
  subnets  = [aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id]
}

resource "aws_lb_target_group" "target-group" {
  name     = "target-group"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
}

resource "aws_default_vpc" "default" {

}
resource "aws_lb_listener" "lb-escutador" {
  load_balancer_arn = aws_lb.load-balancer.arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_autoscaling_policy" "autoscaling-policy-producao" {
  name = "autoscaling-policy-producao"
  autoscaling_group_name = aws_autoscaling_group.grupo.name
  policy_type = "TargetTrackingScaling" # Utiliza uma métrica para escalar (CPU)
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20 # Meta de CPU
    disable_scale_in = false
  }
}