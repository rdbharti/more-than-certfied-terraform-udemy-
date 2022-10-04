# --- networking/outputs.tf

output "vpc_id" {
  value = aws_vpc.rdb_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.rdb_rds_subnetgroup.*.name
}

output "db_security_group" {
  value = [aws_security_group.rdb_sg["rds"].id]
}

output "public_subnets" {
  value = aws_subnet.rdb_public_subnet.*.id
}

output "lb_security_group" {
  value = aws_security_group.rdb_sg["public"].id
}