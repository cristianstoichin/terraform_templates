provider "aws" {
  region = local.region
}

locals {
  region = var.region
}