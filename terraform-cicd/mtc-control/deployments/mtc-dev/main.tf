//--------------------------------------------------------------------
// Variables



//--------------------------------------------------------------------
// Modules
module "compute" {
  source = "app.terraform.io/rdb-aws-terraform/compute/aws"
  #   version = "1.0.0"
  version = "1.0.0"

  aws_region          = "us-east-1"
  instance_count      = 2
  public_key_material = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDafa1ONMMCwpwMi+LaTSbynRxNB19gZ1mb95xdKPNz110eD3cBl94Yxd7RUhV1WyiXjgg1GnomeTrF9Tb99LwlfEG/zFS9xAZI+SBlZ5w0tsg1+nuE+CtV9Ml/P4jd2SDaDN2epZ9W6nRFQpbVh2umAPwIgewYSmTfrWOA/oolflrBW3MkM28R9yZgql5AFifEC0T4rD+XnModY+kjPB5VnGBI3060YS/jGxVzuMeFZfP9ywzWzA7kwdhzHmo82u9/Q1+UVChTZtAvURbPFXLt7ktNOfVG9T08FWq1iGZrJW/+hNQ/sslaFAL6jZNHCFav2w9E+rLzHyWYFiu0Bgdd ubuntu@ip-172-31-29-16"
  public_sg           = module.networking.public_sg
  public_subnets      = module.networking.public_subnets
}

module "networking" {
  source = "app.terraform.io/rdb-aws-terraform/networking/aws"
  #   version = "1.0.0"
  version = "1.0.0"

  access_ip  = "0.0.0.0/0"
  aws_region = "us-east-1"
}