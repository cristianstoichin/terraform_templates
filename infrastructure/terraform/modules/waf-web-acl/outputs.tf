output "web_acl_arn" {
  description = "The ARN of the web_acl"
  value       = aws_wafv2_web_acl.wafv2_web_acl.arn
}