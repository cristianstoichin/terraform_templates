resource "aws_lb_target_group" "this" {
  name          = "${var.name}-${var.environment}"
  vpc_id               = var.vpc_id
  protocol             = "HTTP"
  port                 = var.task_container_port
  target_type          = "ip"
  deregistration_delay = 15
  health_check {
    enabled  = true
    port     = var.task_container_port
    protocol = "HTTP"
    timeout  = 5
    interval = 10
    path     = var.health_check_path
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}