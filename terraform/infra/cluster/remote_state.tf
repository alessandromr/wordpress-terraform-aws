locals {
  vpc_id              = data.terraform_remote_state.shared_infra.outputs.vpc_id
  private_subnets_ids = data.terraform_remote_state.shared_infra.outputs.private_subnets_ids
  public_subnets_ids  = data.terraform_remote_state.shared_infra.outputs.public_subnets_ids
}

data "terraform_remote_state" "shared_infra" {
  backend = "s3"
  config = {
    bucket = "scalable-wp-onaws"
    key    = "example-site/${terraform.workspace}/shared-infra"
    region = "eu-west-1"
  }
}
