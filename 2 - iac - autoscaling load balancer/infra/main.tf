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
  target_group_arns = [aws_lb_target_group.target-group[0].arn]
}

resource "aws_autoscaling_schedule" "liga" {
  scheduled_action_name  = "liga"
  min_size               = 1 # -1 means dont change these values at schedule time
  max_size               = -1
  desired_capacity       = -1
  recurrence = "0 11 * * MON-FRI"
  start_time             = timeadd(timestamp(), "10m")
  autoscaling_group_name = aws_autoscaling_group.grupo.name
}


resource "aws_autoscaling_schedule" "desliga" {
  scheduled_action_name  = "desliga"
  min_size               = 0
  max_size               = -1
  desired_capacity       = 0
  recurrence = "0 21 * * MON-FRI"
  start_time             = timeadd(timestamp(), "11m")
  autoscaling_group_name = aws_autoscaling_group.grupo.name
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
  count = var.producao ? 1 : 0
}

resource "aws_lb_target_group" "target-group" {
  name     = "target-group"
  port     = "8000"
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
  count = var.producao ? 1 : 0
}

resource "aws_default_vpc" "default" {

}
resource "aws_lb_listener" "lb-escutador" {
  load_balancer_arn = aws_lb.load-balancer[0].arn
  port              = "8000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group[0].arn
  }
  count = var.producao ? 1 : 0
}

resource "aws_autoscaling_policy" "autoscaling-policy-producao" {
  name = "autoscaling-policy-producao"
  autoscaling_group_name = aws_autoscaling_group.grupo.name
  policy_type = "TargetTrackingScaling" # Utiliza uma métrica para escalar (CPU)
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50 # Meta de CPU
    disable_scale_in = false
  }
  count = var.producao ? 1 : 0
}