resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.application}-cluster-${var.environment}-${var.created}-logs"
  retention_in_days = var.log_retention
}

# CLoudwatch encryption is enabled by default. If you do not require it, simply comment out lines 14- 24
resource "aws_ecs_cluster" "this" {
  name = "${var.application}-cluster-${var.environment}-${var.created}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = var.kms_encryption_key
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
      }
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }

}