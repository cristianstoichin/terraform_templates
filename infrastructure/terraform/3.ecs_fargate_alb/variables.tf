variable "application" {
  description = "Application name to use"
  type        = string
}

variable "environment" {
  description = "Environment name to use"
  type        = string
}

variable "region" {
  description = "AWS region to use"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Cluster and other components will be deployed to"
  type        = string
}

variable "kms_encryption_key" {
  description = "KMS Key"
  type        = string
}

variable "timestamp" {
  description = "Provide uniqueness for resource names."
  type        = string
}

variable "created" {
  description = "Provide a way to generate static ids."
  type        = string
}

variable "log_retention" {
  description = "CLoudwatch log retention period - 1,7,14,30, etc."
  type        = number
}

variable "dns_name" {
  type = string
}

variable "sub_domain" {
  description = "Desired subdomain to create a DNS record. Ex: app, the cname will be app.yourdomain.com or app-stage.yourdomain.com."
  type        = string
}

variable "cpu" {
  description = "The cpu reserved for the task to run"
  type        = number
  default     = 256
}

variable "memory" {
  description = "The memory reserved for the task to run"
  type        = number
  default     = 512
}

variable "port_mapping" {
  description = "The port that will be mapped to access the container"
  type        = number
  default     = 3000
}

variable "zone_id" {
  type = string
}

variable "min_task_count" {
  description = "Minimum task count."
  type        = string
}

variable "max_task_count" {
  description = "Max task count."
  type        = string
}

variable "health_check_url" {
  description = "Location of the Service healthcheck to be used in the Target Group ALB."
  type        = string
}

variable "initial_image" {
  description = "Location of initial healthcheck endpoint. This is required to exist in order to get the ALB + Target group in a healthy state. Otherwise, the ALB will keep on starting/killing the Tasks."
  type        = string
}

variable "memory_scalling_target_value" {
  description = "Memory scalling policy threshold."
  type        = number
  default     = 70
}

variable "cpu_scalling_target_value" {
  description = "CPU scalling policy threshold."
  type        = number
  default     = 70
}

variable "scale_out_cooldown" {
  description = "The amount of time, in seconds, after a scale out activity completes before another scale out activity can start."
  type        = number
  default     = 60
}

variable "scale_in_cooldown" {
  description = "The amount of time, in seconds, after a scale in activity completes before another scale in activity can start."
  type        = number
  default     = 600
}