terraform {
  required_version = ">= 0.13"

  backend "s3" {}

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.12"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 2.2"
    }
  }
}
