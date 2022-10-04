# --- root/variables.tf ---

variable "aws_region" {
  #  default = "us-west-2"
  default = "eu-north-1"
}

variable "access_ip" {}

variable "world_access_ip" {}


# ---- Database Variabbles ---

variable "db_name" {
  type = string
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}