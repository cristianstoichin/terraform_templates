output "service_arn" {
  description = "The arn of the service"
  value       = aws_ecs_service.this.name
}