locals {
  default_tags = {
    Application = var.name
    Environment = var.environment
  }
}