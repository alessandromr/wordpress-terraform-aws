resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)

  vpc_id            = aws_vpc.base.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = "${var.aws_region}${element(var.availability_zones, count.index)}"

  tags = merge(var.tags,
    {
      Name = "${var.resource_prefix}-${var.env}-subnet-${count.index}-public"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.base.id

  tags = merge(var.tags,
    {
      Name = "${var.resource_prefix}-${var.env}-route-table-public"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.base_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}