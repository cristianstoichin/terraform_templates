variable "application" {
  description = "Application name to use and append to the resource names"
  type        = string
}

variable "bucket" {
  description = "Name of the bucket to store access logs in"
  type        = string
  default     = null
}

variable "internal_facing" {
  description = "Determines whether the ALB is internal facing or not"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "ID of the security group that the ALB will use"
  type        = list(string)
  default     = null
}

variable "subnet_ids" {
  description = "The list of subnets that the service should run in"
  type        = list(string)
  default     = null
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

variable "tags" {
  description = "A map of tags to add to ALB"
  type        = map(string)
  default     = {}
}

variable "created" {
  description = "Provide a way to generate unique static ids."
  type        = string
}

variable "web_acl_arn" {
  description = "Web ACL ARN"
  type        = string
}

variable "region" {
  description = "AWS region to use"
  type        = string
}
