resource "aws_vpc" "base" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = "true"

  tags = merge(var.tags,
    {
      Name = "${var.resource_prefix}-${var.env}-vpc"
    }
  )
}

resource "aws_route53_zone_association" "base" {
  count   = var.include_route53_zone_association == "yes" ? 1 : 0
  zone_id = var.private_zone_id
  vpc_id  = aws_vpc.base.id
}