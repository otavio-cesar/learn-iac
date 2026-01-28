module "aws_dev" {
  instancia = "t3.micro"
  source   = "../../infra"
  regiao_aws = "us-east-1"
  chave    = "IaC-DEV"
  grupo_seguranca = "grupo-seguranca-dev"
}

output "IP" {
  value = module.aws_dev.IP_publico
}

