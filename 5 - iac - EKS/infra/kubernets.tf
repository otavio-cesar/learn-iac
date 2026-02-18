resource "kubernetes_deployment_v1" "Django_API-deployment" {
  metadata {
    name = "django-api-deployment"
    labels = {
      test = "django-${var.ambiente}"
    }
  }

  spec {
    replicas = 2

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

          # liveness_probe {
          #   http_get {
          #     path = "/clientes"
          #     port = 8000
          #   }

          #   initial_delay_seconds = 20
          #   period_seconds        = 61
          # }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "LoadBalancer" {
  metadata {
    name = "load-balancer-django-api"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }

  }
  spec {
    selector = {
      test = "django-${var.ambiente}"
    }
    port {
      port = 8000
      target_port = 8000
    }
    type = "LoadBalancer"
  }
}

data "kubernetes_service" "nomeDNS" {
  depends_on = [ kubernetes_service_v1.LoadBalancer ]
    metadata {
      name = "load-balancer-django-api"
    }
}

output "URL" {
  value = data.kubernetes_service.nomeDNS.status
}