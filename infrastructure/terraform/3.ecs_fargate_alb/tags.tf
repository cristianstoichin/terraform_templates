locals {
  default_tags = {
    Application = var.application
    Environment = var.environment
    UpdatedTime = var.timestamp
    Created     = var.created
  }
}