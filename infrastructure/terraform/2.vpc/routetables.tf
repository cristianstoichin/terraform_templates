#Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  depends_on = [aws_internet_gateway.igw]
  tags = merge(
    local.default_tags,
    {
      Name = "public-route-table-${aws_vpc.vpc.id}",
    }
  )
}

#Associate Public Route Table to Public Subnets
resource "aws_route_table_association" "public_route_association1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
  depends_on     = [aws_route_table.public_route_table, aws_subnet.public_subnet_1]
}

resource "aws_route_table_association" "public_route_association2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
  depends_on     = [aws_route_table.public_route_table, aws_subnet.public_subnet_2]
}

resource "aws_route_table_association" "public_route_association3" {
  count          = var.enable_third_subnet ? 1 : 0
  subnet_id      = aws_subnet.public_subnet_3[0].id
  route_table_id = aws_route_table.public_route_table.id
  depends_on     = [aws_route_table.public_route_table, aws_subnet.public_subnet_3]
}

#Private Route Table
resource "aws_route_table" "private_route_table1" {
  count         = var.enable_nat ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw1[0].id
  }
  depends_on = [aws_nat_gateway.ngw1]
  tags = merge(
    local.default_tags,
    {
      Name = "private-route-table1-${aws_vpc.vpc.id}",
    }
  )
}

resource "aws_route_table" "private_route_table2" {
  count  = var.single_nat ? 0 : 1
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw2[0].id
  }
  depends_on = [aws_nat_gateway.ngw2]
  tags = merge(
    local.default_tags,
    {
      Name = "private-route-table2-${aws_vpc.vpc.id}",
    }
  )
}

resource "aws_route_table" "private_route_table3" {
  count  = !var.single_nat && var.enable_third_subnet ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw3[0].id
  }
  depends_on = [aws_nat_gateway.ngw3]
  tags = merge(
    local.default_tags,
    {
      Name = "private-route-table3-${aws_vpc.vpc.id}",
    }
  )
}

#Associate Private Route Table to Private Subnets
resource "aws_route_table_association" "private_route_association1" {
  count          = var.enable_nat ? 1 : 0
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table1[0].id
  depends_on     = [aws_route_table.private_route_table1, aws_subnet.private_subnet_1]
}

resource "aws_route_table_association" "private_route_association2" {
  count          = var.enable_nat ? 1 : 0
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = var.single_nat ? aws_route_table.private_route_table1[0].id : aws_route_table.private_route_table2[0].id
}

resource "aws_route_table_association" "private_route_association3" {
  count          = var.enable_third_subnet && !var.enable_nat ? 1 : 0
  subnet_id      = aws_subnet.private_subnet_3[0].id
  route_table_id = var.single_nat ? aws_route_table.private_route_table1[0].id : aws_route_table.private_route_table3[0].id
}