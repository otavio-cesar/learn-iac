# resource "aws_ecr_repository" "repositorio_ecr" {
#   name = var.nome_repo_ecr
#   force_delete = true
# }

resource "aws_ecrpublic_repository" "repositorio_ecr_publico" {
  repository_name = var.nome_repo_ecr

  catalog_data {
    description = "Repositório público ECR"
  }
}

output "Repo-End" {
  value = aws_ecrpublic_repository.repositorio_ecr_publico.repository_uri
}