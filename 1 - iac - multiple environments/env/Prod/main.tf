module "aws_prod" {
  instancia = "t2.micro"
  source   = "../../infra"
  regiao_aws = "us-east-1"
  chave    = "IaC-PROD"
  grupo_seguranca = "grupo-seguranca-prod"
}

output "IP" {
  value = module.aws_prod.IP_publico
}

