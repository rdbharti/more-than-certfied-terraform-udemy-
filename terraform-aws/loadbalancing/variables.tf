# --- loadbalancing/variables.tf ---

variable "public_subnets" {}

variable "public_sg" {}

# -- lb target group Variables --

variable "tg_port" {}
variable "tg_protocol" {}
variable "vpc_id" {}
variable "lb_healthy_threshold" {}
variable "lb_unhealthy_threshold" {}
variable "lb_timeout" {}
variable "lb_interval" {}
variable "listener_protocol" {}
variable "listerner_port" {}