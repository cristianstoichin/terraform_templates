provider "aws" {
  region = local.region

  default_tags {
    tags =  local.default_tags
  } 
}

locals {
  region = var.region
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

#----------------------------------------------------------
#   Certificate 
#----------------------------------------------------------
