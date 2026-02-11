module "aws_dev" {
  source   = "../../infra"
  
  ambiente = "ambiente-dev"
  descricao = "aplicacao-homologacao"
  maquina = "t3.micro"
  regiao_aws = "us-east-1"
  nome_repo_ecr = "ecs-repo"
  nome = "ecs-api"
  versao = "v1"
}

output "IP_alb" {
  value = module.aws_dev.IP
}

output "Repo-End" {
  value = module.aws_dev.Repo-End
}