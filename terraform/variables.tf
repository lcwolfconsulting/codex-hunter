variable "db_user" {
  type    = string
  default = "codex_user"
}

variable "db_password" {
  type      = string
  default   = "codex_password"
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "codex_db"
}

variable "frontend_port" {
  type    = number
  default = 8080
}
