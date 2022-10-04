terraform {
    backend "remote" {
        organization = "rdb-aws-terraform"
        
        workspaces {
            name = "rdb-dev-repo"
        }
    }
}