module "aws_dev" {
  instancia = "t2.micro"
  source   = "../../infra"
  regiao_aws = "us-east-1"
  chave    = "IaC-DEV2"
  grupo_seguranca = "grupo-seguranca-dev"
  minimo = 1
  maximo = 2
  nomeGrupo = "Dev-AutoScaling"
}