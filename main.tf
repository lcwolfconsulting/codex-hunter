terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

# 1. Réseau isolé pour Codex Hunter
resource "docker_network" "codex_net" {
  name = "codex_network"
}

# 2. Image PostgreSQL (base de données Pokémon)
resource "docker_image" "postgres" {
  name         = "postgres:15-alpine"
  keep_locally = true
}

# 3. Conteneur BDD PostgreSQL
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

# 4. Image Frontend Codex Hunter (existante localement)
resource "docker_image" "frontend_image" {
  name         = "codex-hunter-frontend:latest"
  keep_locally = true
}

# 5. Conteneur Frontend (collection & visuels Pokémon)
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
