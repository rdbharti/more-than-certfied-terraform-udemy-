# --- networking/main.tf ----

data "aws_availability_zones" "available" {}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

# -- Creating VPC --
resource "aws_vpc" "rdb_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "rdb_vpc-${random_integer.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# -- Creating SUBNETs [Public] --
resource "aws_subnet" "rdb_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.rdb_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "rdb_public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "rdb_public_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.rdb_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.rdb_public_rt.id
}

# -- Creating SUBNETs [Private] --
resource "aws_subnet" "rdb_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.rdb_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "rdb_private_${count.index + 1}"
  }
}

# -- Creating Internet Gateway --
resource "aws_internet_gateway" "rdb_IGW" {
  vpc_id = aws_vpc.rdb_vpc.id

  tags = {
    Name = "rdb_igw"
  }
}

# -- Creating Route Table --
resource "aws_route_table" "rdb_public_rt" {
  vpc_id = aws_vpc.rdb_vpc.id

  tags = {
    Name = "rdb_public"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.rdb_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rdb_IGW.id
}

resource "aws_default_route_table" "rdb_private_rt" {
  default_route_table_id = aws_vpc.rdb_vpc.default_route_table_id

  tags = {
    Name = "rdb_private"
  }
}

resource "aws_security_group" "rdb_sg" {

  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.rdb_vpc.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rdb_rds_subnetgroup" {
  count      = var.db_subnet_group ? 1 : 0
  name       = "rdb_rds_subnetgroup"
  subnet_ids = aws_subnet.rdb_private_subnet.*.id

  tags = {
    Name = "rdb_rds_sng"
  }
}