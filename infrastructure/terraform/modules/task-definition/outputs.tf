output "task_container_name" {
  description = "The task container name."
  value       = "${var.container_name}-${var.environment}"
}

output "task_container_port" {
  description = "The port that the container is mapped to."
  value       = var.port_mapping
}

output "task_definition_arn" {
  description = "Full ARN of the Task Definition (including both family and revision)."
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
  description = "Full name of the Task Definition."
  value       = aws_ecs_task_definition.this.family
}
