locals {
  default_tags = {
    Name   = "${var.name}-${var.environment}"
    Environment   = var.environment
    UpdatedTime = var.timestamp
    Created = var.created
  }
}