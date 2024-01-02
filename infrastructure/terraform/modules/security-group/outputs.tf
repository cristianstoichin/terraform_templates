output "security_group_name" {
  description = "The Group name"
  value       = var.name
}

output "security_group_id" {
  description = "The Group ID"
  value       = aws_security_group.this.id
}