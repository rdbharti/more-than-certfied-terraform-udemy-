
variable "external_port" {
  type = map(any)
  //default = [1880, 1881]

  validation {
    condition     = max(var.external_port["prod"]...) < 1900 && min(var.external_port["prod"]...) >= 1880
    error_message = "Range of ports in Production is [1880-1900]."
  }

  validation {
    condition     = max(var.external_port["dev"]...) < 65535 && min(var.external_port["dev"]...) >= 1980
    error_message = "Range of ports in Production is [1880-1900]."
  }
}

locals {
  count = length(var.external_port)
}

variable "image_type" {
  type = map(any)
  default = {
    dev  = "nodered/node-red:latest"
    prod = "nodered/node-red:latest-minimal"
  }
}