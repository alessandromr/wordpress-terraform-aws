module "basic_infra" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.58.0"

  name = "${local.prefix}-${terraform.workspace}"
  cidr = "10.0.0.0/20"

  azs              = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets  = ["10.0.0.0/23", "10.0.2.0/23", "10.0.4.0/23"]
  public_subnets   = ["10.0.8.0/24", "10.0.9.0/24", "10.0.10.0/24"]
  database_subnets = ["10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = var.single_nat_gateway

  enable_vpn_gateway = false

  tags = var.tags
}
