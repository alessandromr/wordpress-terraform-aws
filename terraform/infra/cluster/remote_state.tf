locals {
  vpc_id              = data.terraform_remote_state.shared_infra.outputs.vpc_id
  private_subnets_ids = data.terraform_remote_state.shared_infra.outputs.private_subnets_ids
}

data "terraform_remote_state" "shared_infra" {
  backend = "local"
  config = {
    path = "../shared/"
  }
}
