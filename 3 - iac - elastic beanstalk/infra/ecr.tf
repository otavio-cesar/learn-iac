resource "aws_ecr_repository" "repositorio_ecr" {
  name = var.nome_repo_ecr
  image_scanning_configuration {
    scan_on_push = true
  }
}
