terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

# Réseau isolé pour Codex Hunter
resource "docker_network" "codex_net" {
  name = "codex_network"
}

# Image BDD PostgreSQL
resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = true
}

# Conteneur Base de Données (cartes & scans Pokémon)
resource "docker_container" "db" {
  image = docker_image.postgres.image_id
  name  = "codex-db-tf"

  networks_advanced {
    name = docker_network.codex_net.name
  }

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  ports {
    internal = 5432
    external = 5432
  }
}

# Image Frontend depuis GHCR
resource "docker_image" "frontend_image" {
  name         = var.frontend_image_name
  keep_locally = true
}

# Conteneur Frontend (Interface Codex Hunter)
resource "docker_container" "frontend" {
  image = docker_image.frontend_image.image_id
  name  = "codex-frontend-tf"

  networks_advanced {
    name = docker_network.codex_net.name
  }

  ports {
    internal = 80
    external = var.frontend_port
  }
}
