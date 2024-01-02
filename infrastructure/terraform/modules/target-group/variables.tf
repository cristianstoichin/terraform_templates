variable "health_check_path" {
  description = "Path to the health check on the supported service"
  type        = string
  default     = null
}

variable "listener_arn" {
  description = "ARN of the listener that the new rule will be added to"
  type        = string
  default     = null
}

variable "path_patterns" {
  description = "The path patterns that the listener rules will use"
  type        = list(string)
  default     = null
}

variable "name" {
  description = "Prefix to identify target group"
  type        = string
  default     = null
}

variable "priority" {
  description = "Priority of the rule that routes to the target group"
  type        = number
  default     = null
}

variable "task_container_port" {
  description = "The port that the target group container is exposed on and the ALB should forward to"
  type        = string
  default     = 3000
}

variable "tags" {
  description = "A map of tags to add"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "The VPC ID that the ALB should be associated with"
  type        = string
  default     = null
}

variable "environment" {
  description = "Environment to be added on all the resources to the identifier"
  type        = string
  default     = null
}

variable "created" {
  description = "Provide a way to generate static ids."
  type        = string
}

variable "ssl_policy" {
  default     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  type        = string
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS."
}

variable "load_balancer_arn" {
  type        = string
}

variable "cert_arn" {
  type        = string
}