variable "int_port" {
  type    = number
  default = 1880

  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}

# variable "container_count" {
#   type    = number
#   default = 3
# }

variable "ext_port" {
  type = map(any)

  # validation {

  #   condition = max(var.ext_port["nodered"]["dev"]...) < 65535 && min(var.ext_port["nodered"]["dev"]...) >= 1980
  #   #   condition     = var.ext_port <= 65535 && var.ext_port > 0
  #   error_message = "The external port range [1980 - 65535]."
  # }

  # validation {

  #   condition = max(var.ext_port["nodered"]["prod"]...) < 1980 && min(var.ext_port["nodered"]["prod"]...) >= 1880
  #   #   condition     = var.ext_port <= 65535 && var.ext_port > 0
  #   error_message = "The external port range [1880 - 65535]."
  # }
}


# variable "env" {
#   type        = string
#   description = "Environment to deploy to."
#   default     = "dev"
# }

variable "image" {
  type        = map(any)
  description = "Image for Container."
  default = {
    nodered = {
      dev  = "nodered/node-red:latest"
      prod = "nodered/node-red:latest-minimal"
    }

    influxdb = {
      dev  = "quay.io/influxdb/influxdb:v2.0.2"
      prod = "quay.io/influxdb/influxdb:v2.0.2"
    }

    grafana = {
      dev  = "grafana/grafana"
      prod = "grafana/grafana"
    }

  }
}