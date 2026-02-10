module "aws_dev" {
  source   = "../../infra"
  
  ambiente = "ambiente-dev"
  descricao = "aplicacao-homologacao"
  maquina = "t3.micro"
  regiao_aws = "us-east-1"
  nome_repo_ecr = "ecs-repo"
  maximo = 1
  nome = "ecs-api"
  versao = "v1"
}

output "IP_alb" {
  value = module.aws_dev.IP
}