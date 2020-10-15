resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)

  vpc_id            = aws_vpc.base.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = "${var.aws_region}${element(var.availability_zones, count.index)}"

  tags = merge(var.tags,
    {
      Name = "${var.resource_prefix}-${var.env}-subnet-${count.index}-private"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.base.id

  tags = merge(var.tags,
    {
      Name = "${var.resource_prefix}-${var.env}-route-table-private"
    }
  )
}

resource "aws_route" "private_internet_natgw" {
  count                  = var.include_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = element(aws_nat_gateway.base.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}