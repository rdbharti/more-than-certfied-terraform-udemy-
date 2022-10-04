output "ip_address" {
  value = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
}

output "container" {
  value = docker_container.nodered_container[*].name
}