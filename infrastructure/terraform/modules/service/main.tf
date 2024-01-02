resource "aws_ecs_service" "this" {
  name                    = "${var.service_name}-${var.environment}"
  cluster                 = var.cluster_id
  task_definition         = var.task_definition_arn
  launch_type             = "FARGATE"
  enable_execute_command  = true
  enable_ecs_managed_tags = true
  desired_count           = 1
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.task_security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.task_container_name
    container_port   = var.task_container_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_appautoscaling_target" "task" {
  min_capacity = var.min_task_count
  max_capacity = var.max_task_count

  resource_id        =  "service/${var.cluster_name}/${var.service_name}-${var.environment}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

#------------------------------------------------------------------------------
# AWS CPU Auto Scaling Policy
#------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "scale_up_policy_cpu" {
  name               = "${var.service_name}-cpu-${var.environment}-${var.created}-scale-up-policy"
  depends_on         = [aws_ecs_service.this, aws_appautoscaling_target.task]
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.task.resource_id
  policy_type = "TargetTrackingScaling"
  scalable_dimension = "ecs:service:DesiredCount"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    target_value = var.cpu_scalling_target_value
  }
}

#------------------------------------------------------------------------------
# AWS Memory Auto Scaling Policy
#------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "scale_up_policy_memory" {
  name               = "${var.service_name}-memory-${var.environment}-${var.created}-scale-up-policy"
  depends_on         = [aws_ecs_service.this, aws_appautoscaling_target.task, aws_appautoscaling_policy.scale_up_policy_cpu]
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.task.resource_id
  policy_type = "TargetTrackingScaling"
  scalable_dimension = "ecs:service:DesiredCount"
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
    target_value = var.memory_scalling_target_value
  }
}