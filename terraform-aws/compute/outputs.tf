# --- compute/outputs.tf ---

output "instance" {
  value = aws_instance.rdb_node[*]
}

output "instance_port" {
  value = aws_lb_target_group_attachment.rdb_tg_attach[0].port
}