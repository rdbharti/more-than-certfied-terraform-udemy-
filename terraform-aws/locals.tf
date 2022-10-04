# --- root/locals.tf ---

locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    rds = {
      name        = "rds_sg"
      description = "Security Groupp for RDS Access"
      ingress = {
        rds_port = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }

    }

    public = {
      name        = "public_sg"
      description = "Security Groupp for Public Access"
      ingress = {
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        open = {
          from        = 0
          to          = 0
          protocol    = "-1"
          cidr_blocks = [var.access_ip]
        }
        nginx = {
          from        = 8000
          to          = 8000
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}
