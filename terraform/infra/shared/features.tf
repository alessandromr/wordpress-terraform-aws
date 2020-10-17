module "basic_infra" {
  source = "git@github.com:alessandromr/terraform.feature.network.git"

  aws_region      = data.aws_region.current.id
  aws_account_id  = data.aws_caller_identity.current.id
  resource_prefix = local.prefix
  env             = terraform.workspace

  vpc_cidr             = "10.0.0.0/22"
  availability_zones   = ["a", "b"]
  public_subnets_cidr  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets_cidr = ["10.0.2.0/24", "10.0.3.0/24"]

  include_nat_gateway = true

  tags = var.tags
}