terraform {
  cloud {
    organization = "rdb-aws-terraform"

    workspaces {
      name = "rdb-dev"
    }
  }
}