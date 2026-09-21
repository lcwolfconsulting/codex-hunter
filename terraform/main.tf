terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "codex_hunter" {
  name      = "codex-app-tf"
  chart     = "../codex-chart"
  namespace = "default"

  values = [
    <<-EOT
    frontend:
      replicaCount: 2
    EOT
  ]
}
