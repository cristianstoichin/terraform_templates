#Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
    # public subnet 1 cidr block iteration found in the terraform.tfvars file
    cidr_block = var.public_subnet_1_cidr
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
    #0 indicates the first AZ
    availability_zone = data.aws_availability_zones.available.names[0]
    
    tags =  merge(
        local.default_tags,
        {
            Name = "public-subnet-1-${aws_vpc.vpc.id}",
            SUB-TYPE = "Public"
        }
    )
}

#Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
    # public subnet 2 cidr block iteration found in the terraform.tfvars file
    cidr_block = var.public_subnet_2_cidr
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
    #1 indicates the second AZ
    availability_zone = data.aws_availability_zones.available.names[1]
    
    tags =  merge(
        local.default_tags,
        {
            Name = "public-subnet-2-${aws_vpc.vpc.id}",
            SUB-TYPE = "Public"
        }
    )
}

#Public Subnet 3
resource "aws_subnet" "public_subnet_3" {
    # public subnet 3 cidr block iteration found in the terraform.tfvars file
    count = var.enable_third_subnet ? 1 : 0
    cidr_block = var.public_subnet_3_cidr
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = true
    #2 indicates the third AZ
    availability_zone = data.aws_availability_zones.available.names[2]
    
    tags =  merge(
        local.default_tags,
        {
            Name = "public-subnet-3-${aws_vpc.vpc.id}",
            SUB-TYPE = "Public"
        }
    )
}

#Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
    # private subnet 1 cidr block iteration found in the terraform.tfvars file
    cidr_block = var.private_subnet_1_cidr
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = false
    #0 indicates the first AZ
    availability_zone = data.aws_availability_zones.available.names[0]
    
    tags =  merge(
        local.default_tags,
        {
            Name = "private-subnet-1-${aws_vpc.vpc.id}",
            SUB-TYPE = "Private"
        }
    )
}

#Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
    #private subnet 2 cidr block iteration found in the terraform.tfvars file
    cidr_block = var.private_subnet_2_cidr
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = false
    #1 indicates the second AZ
    availability_zone = data.aws_availability_zones.available.names[1]
    
    tags =  merge(
        local.default_tags,
        {
            Name = "private-subnet-2-${aws_vpc.vpc.id}",
            SUB-TYPE = "Private"
        }
    )
}

#Private Subnet 3
resource "aws_subnet" "private_subnet_3" {
    # private subnet 3 cidr block iteration found in the terraform.tfvars file
    count = var.enable_third_subnet ? 1 : 0
    cidr_block = var.private_subnet_3_cidr
    vpc_id = aws_vpc.vpc.id
    map_public_ip_on_launch = false
    #2 indicates the third AZ
    availability_zone = data.aws_availability_zones.available.names[2]
    
    tags =  merge(
        local.default_tags,
        {
            Name = "private-subnet-3-${aws_vpc.vpc.id}",
            SUB-TYPE = "Private"
        }
    )
}