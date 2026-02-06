resource "aws_ecr_repository" "repositorio_ecr" {
  name = var.nome_repo_ecr
  force_delete = true
}
