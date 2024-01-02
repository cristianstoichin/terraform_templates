output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "alb_id" {
  description = "The ID of the load balancer"
  value       = aws_lb.this.id
}

output "alb_zone_id" {
  description = "The Zone ID of the load balancer"
  value       = aws_lb.this.zone_id
}