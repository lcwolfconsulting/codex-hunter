variable "db_user" {
  description = "Utilisateur BDD"
  type        = string
  default     = "codex_user"
}

variable "db_password" {
  description = "Mot de passe BDD"
  type        = string
  default     = "codex_secret_pass"
}

variable "db_name" {
  description = "Nom BDD"
  type        = string
  default     = "codex_hunter_db"
}

variable "frontend_port" {
  description = "Port d'ecoute du frontend"
  type        = number
  default     = 8080
}

variable "frontend_image_name" {
  description = "Image Docker du frontend sur GHCR"
  type        = string
  default     = "ghcr.io/lcwolfconsulting/codex-hunter-frontend:latest"
}
