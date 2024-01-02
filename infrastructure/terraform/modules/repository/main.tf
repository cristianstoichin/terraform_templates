resource "aws_ecr_repository" "this" {
  name                 = "ecs-${var.application}-${var.environment}-${var.created}"
  image_tag_mutability = "MUTABLE"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }

}