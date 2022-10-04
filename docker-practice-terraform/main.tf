terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }
  }
}

provider "docker" {}

# resource "null_resource" "ip_address_machine" {
#   provisioner "local-exec" {
#     command = "/bin/bash ip_show.sh"
#   }
# }


resource "null_resource" "directory" {
  provisioner "local-exec" {
    command = "mkdir localvol/ || true && chown -R 1000:1000 localvol/"
  }
}

resource "random_string" "random" {
  count   = local.count
  length  = 5
  special = false
}

resource "docker_image" "nodered_image" {
  name = var.image_type[terraform.workspace]

}

resource "docker_container" "nodered_container" {
  count = local.count
  name  = join("-", ["myNodered", terraform.workspace, random_string.random[count.index].result])
  image = docker_image.nodered_image.name

  ports {
    internal = 1880
    external = var.external_port[terraform.workspace][count.index]
  }

  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/localvol"
  }
}



