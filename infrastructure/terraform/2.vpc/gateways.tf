resource "aws_eip" "nat1" {
  domain   = "vpc"
  tags = local.default_tags
}

resource "aws_eip" "nat2" {
  domain   = "vpc"
  count = var.single_nat ? 0 : 1
  tags  = local.default_tags
}

resource "aws_eip" "nat3" {
  domain   = "vpc"
  count = !var.single_nat && var.enable_third_subnet ? 1 : 0
  tags  = local.default_tags
}

#NAT Gateway object and attachment of the Elastic IP Address from above
resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_subnet_1.id
  depends_on    = [aws_internet_gateway.igw]
  tags          = local.default_tags
}

resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.nat2[0].id
  count         = var.single_nat ? 0 : 1
  subnet_id     = aws_subnet.public_subnet_2.id
  depends_on    = [aws_internet_gateway.igw]
  tags          = local.default_tags
}

resource "aws_nat_gateway" "ngw3" {
  count         = !var.single_nat && var.enable_third_subnet ? 1 : 0
  allocation_id = aws_eip.nat3[0].id
  subnet_id     = aws_subnet.public_subnet_3[0].id
  depends_on    = [aws_internet_gateway.igw]
  tags          = local.default_tags
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.default_tags

  lifecycle {
    create_before_destroy = true
  }

}