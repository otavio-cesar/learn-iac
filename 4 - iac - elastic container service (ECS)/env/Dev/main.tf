module "aws_dev" {
  ambiente = "ambiente-dev"
  descricao = "aplicacao-homologacao"
  maquina = "t3.micro"
  source   = "../../infra"
  regiao_aws = "us-east-1"
  nome_repo_ecr = "ecs-repo"
  maximo = 1
  nome = "ecs-api"
  versao = "v1"
}
