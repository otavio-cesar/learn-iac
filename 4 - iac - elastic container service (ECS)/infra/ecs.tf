module "ecs" {
  source       = "terraform-aws-modules/ecs/aws"
  version      = "~> 7.3"
  
  cluster_name = "ecs-integrated"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  cluster_capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 50
      base   = 20
    }
  }
}

resource "aws_ecs_task_definition" "django-api" {
  family                   = "Django-api"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc" #Necessario para o Fargate
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode(
    [
      {
        "name"      = "ecs-container"
        "image"     = "public.ecr.aws/n2a9h7x9/ecs-repo"
        "cpu"       = 1024
        "memory"    = 2048
        "essential" = true
        "portMappings" = [
          {
            "containerPort" = 8000
            "hostPort"      = 8000
          }
        ]
      }
    ]
  )
}

resource "aws_ecs_service" "Django" {
  name            = "Django-api-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.django-api.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.alvo.arn
    container_name   = "ecs-container"
    container_port   = 8000
  }

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.privado.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}
