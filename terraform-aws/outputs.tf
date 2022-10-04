# --- root/outputs.tf ---

output "lb_endpoint" {
  value = module.loadbalancing.lb_endpoint
}

output "instances" {
  value = { for i in module.compute.instance : i.tags.Name => "${i.public_ip}:${module.compute.instance_port}" }
  sensitive = true
}

output "kubeconfig" {
  value     = [for i in module.compute.instance : "export KUBECONFIG=../k3s-${i.tags.Name}.yaml"]
  sensitive = true
}