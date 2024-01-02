resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  # cidr block iteration found in the terraform.tfvars file
  enable_dns_hostnames = true
  tags                 = local.default_tags
}