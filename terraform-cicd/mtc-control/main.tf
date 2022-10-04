# --- root/main.tf ---


locals {
  aws_creds = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  }

  organization = "rdb-aws-terraform"
}


resource "github_repository" "rdb_repo" {
  name             = "rdb-dev-repo"
  description      = "VPC and COMPPUTE Resource"
  auto_init        = true
  license_template = "mit"

  visibility = "private"
}

resource "github_branch_default" "default" {
  repository = github_repository.rdb_repo.name
  branch     = "main"
}

resource "github_repository_file" "maintf" {
  repository          = github_repository.rdb_repo.name
  branch              = "main"
  file                = "main.tf"
  content             = file("./deployments/mtc-dev/main.tf")
  commit_message      = "Managed By Terraform"
  commit_author       = "RDB"
  commit_email        = "hucka_pani@yahoo.com"
  overwrite_on_create = true
}

resource "tfe_oauth_client" "rdb_oauth" {
  organization     = local.organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "rdb_workspace" {
  name         = github_repository.rdb_repo.name
  organization = local.organization
  vcs_repo {
    identifier     = "${var.github_owner}/${github_repository.rdb_repo.name}"
    oauth_token_id = tfe_oauth_client.rdb_oauth.oauth_token_id
  }
}

resource "tfe_variable" "aws_creds" {
  for_each     = local.aws_creds
  key          = each.key
  value        = each.value
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.rdb_workspace.id
  description  = "aws creds"
}