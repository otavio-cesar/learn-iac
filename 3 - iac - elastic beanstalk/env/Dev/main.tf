module "aws_dev" {
  ambiente = "ambiente-dev"
  descricao = "Ambiente de Desenvolvimento"
  maquina = "t2.micro"
  source   = "../../infra"
  regiao_aws = "us-east-1"
  nome_repo_ecr = "repo-ecr-dev"
  maximo = 2
  nome = "desenvolvimento"
  versao = "1.0.0"
}
