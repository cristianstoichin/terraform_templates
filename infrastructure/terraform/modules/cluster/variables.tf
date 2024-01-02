variable "environment" {
  description = "Environment to be added on all the resources to the identifier"
  type        = string
  default     = null
}

variable "application" {
  description = "Application name to use and append to the resource names"
  type        = string
}

variable "kms_encryption_key" {
  description = "ID of the KMS key to use for execute command configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to ECS Cluster"
  type        = map(string)
  default     = {}
}

variable "created" {
  description = "Provide a way to generate static ids."
  type        = string
}

variable "log_retention" {
  description = "CLoudwatch log retention period - 1,7,14,30, etc."
  type        = number
}

