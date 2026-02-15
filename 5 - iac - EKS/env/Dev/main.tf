module "aws_dev" {
  source   = "../../infra"
  
  ambiente = "ambiente-dev"
  maquina = "t3.micro"
  regiao_aws = "us-east-1"
  nome_repo_ecr = "ecs-repo"
  cluster_name = "eksdev"
}
