module "aws_dev" {
  source   = "../../infra"
  
  ambiente = "ambiente-dev"
  maquina = "t3.micro"
  regiao_aws = "us-east-1"
  nome_repo_ecr = "ecs-repo"
  cluster_name = "eksdev"
}

# output "endereco" {
#   value = module.aws_dev.URL
# }

# output "cluster_cidr"{
#     value = module.aws_dev.cluster_service_cidr
# }
