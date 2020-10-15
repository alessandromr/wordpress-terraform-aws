resource "aws_internet_gateway" "base_igw" {
  vpc_id = aws_vpc.base.id

  tags = merge(var.tags,
    {
      Name = "${var.resource_prefix}-${var.env}-base_igw"
    }
  )
}