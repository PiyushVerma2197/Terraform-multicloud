resource "local_file" "petclinic_ingress" {
  filename = "${path.root}/spring-petclinic/k8s/generated-ingress.yaml"
  content = templatefile(
    "${path.root}/spring-petclinic/k8s/ingress.yaml.tftpl",
    {
      domain_name = "${var.petclinic_subdomain}.${var.route53_domain}"
    }
  )
}


data "aws_secretsmanager_secret_version" "rds" {
  secret_id = module.aws_vpc.rds_master_user_secret_arn
}

locals {
  rds_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.rds.secret_string
  )
}

resource "kubernetes_secret_v1" "petclinic_rds" {
  metadata {
    name      = "petclinic-rds"
    namespace = "default"
  }

  type = "Opaque"

  data = {
    POSTGRES_URL = "jdbc:postgresql://${module.aws_vpc.rds_endpoint}:${module.aws_vpc.rds_port}/${module.aws_vpc.rds_database_name}"

    POSTGRES_USER = local.rds_credentials.username

    POSTGRES_PASS = local.rds_credentials.password
  }

  depends_on = [
    module.aws_vpc
  ]
}


resource "kubernetes_deployment_v1" "ingress_healthcheck" {

  metadata {
    name      = "ingress-healthcheck"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ingress-healthcheck"
      }
    }

    template {

      metadata {
        labels = {
          app = "ingress-healthcheck"
        }
      }

      spec {

        container {
          name  = "healthcheck"
          image = "hashicorp/http-echo:1.0"

          args = [
            "-text=OK",
            "-listen=:8080"
          ]

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}


resource "kubernetes_service_v1" "ingress_healthcheck" {

  metadata {
    name      = "ingress-healthcheck"
    namespace = "default"
  }

  spec {

    selector = {
      app = "ingress-healthcheck"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8080
    }
  }
}


resource "kubernetes_ingress_v1" "ingress_healthcheck" {

  metadata {
    name      = "ingress-healthcheck"
    namespace = "default"
  }

  spec {

    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/healthz"
          path_type = "Exact"
          backend {
            service {
              name = kubernetes_service_v1.ingress_healthcheck.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.nginx_ingress
  ]
}