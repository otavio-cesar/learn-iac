module "aws_dev" {
  ambiente = "ambiente-dev"
  descricao = "aplicacao-homologacao"
  maquina = "t2.micro"
  source   = "../../infra"
  regiao_aws = "us-east-1"
  nome_repo_ecr = "repo-ecr-dev"
  maximo = 2
  nome = "meu-app"
  versao = "v7"
}
