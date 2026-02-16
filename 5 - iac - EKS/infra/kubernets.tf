resource "kubernetes_deployment_v1" "Django_API-deployment" {
  metadata {
    name = "django-api-deployment"
    labels = {
      test = "django-${var.ambiente}"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "django-${var.ambiente}"
      }
    }

    template {
      metadata {
        labels = {
          test = "django-${var.ambiente}"
        }
      }

      spec {
        container {
          image = "public.ecr.aws/n2a9h7x9/ecs-repo"
          name  = "django-${var.ambiente}"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/clientes"
              port = 8000
            }

            initial_delay_seconds = 10
            period_seconds        = 3
          }
        }
      }
    }
  }
}