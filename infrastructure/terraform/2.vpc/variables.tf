variable "name" {
  description = "Name to use"
  type        = string
}

variable "environment" {
  description = "Environment name to use"
  type        = string
}

variable "region" {
  description = "AWS region to use"
  type        = string
}

variable "timestamp" {
  description = "Provide uniqueness for resource names."
  type        = string
}

variable "created" {
  description = "Provide a way to generate static ids."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC Cidr range."
  type        = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "public_subnet_3_cidr" {
  type = string
}

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}

variable "private_subnet_3_cidr" {
  type = string
}

variable "enable_third_subnet" {
  type    = bool
  default = false
}

variable "single_nat" {
  type        = bool
  description = "To save on cost for development switch this to true. All private azs will point to the same NAT, losing high availablility."
  default     = false
}

variable "enable_nat" {
  type        = bool
  description = "To save on cost for development switch this to true, but you will have no private subnets."
  default     = false
}
