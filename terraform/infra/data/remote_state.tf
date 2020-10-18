locals {
  vpc_id                 = data.terraform_remote_state.shared_infra.outputs.vpc_id
  database_subnets_ids   = data.terraform_remote_state.shared_infra.outputs.database_subnets_ids
  database_subnets_group = data.terraform_remote_state.shared_infra.outputs.database_subnets_group
  azs                    = data.terraform_remote_state.shared_infra.outputs.azs
}

data "terraform_remote_state" "shared_infra" {
  backend = "s3"
  config = {
    bucket = "scalable-wp-onaws"
    key    = "example-site/${terraform.workspace}/shared-infra"
    region = "eu-west-1"
  }
}
