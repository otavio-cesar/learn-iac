module "aws_dev" {
  ambiente = "ambiente-dev"
  descricao = "aplicacao-homologacao"
  maquina = "t3.micro"
  source   = "../../infra"
  regiao_aws = "us-east-1"
  nome_repo_ecr = "repo-ecr-dev"
  maximo = 1
  nome = "clientes-api"
  versao = "v1"
}
