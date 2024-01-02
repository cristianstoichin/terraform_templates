variable "kms_encryption_key" {
  description = "KMS Key"
  type        = string
  default = null
}

variable "environment" {
  description = "Environment to be added on all the resources to the identifier"
  type        = string
  default     = null
}

variable "application" {
  description = "Application name to use and append to the resource names"
  type        = string
}

variable "alb_log_lifecycle_to_infrequent_access_days" {
  description = "Define the ALB S3 logs storage lifecycle policy. TO save on cost, files older than the defined number of days, will be moved to S3 IA class type."
  type        = number
  default     = 90
}

variable "tags" {
  description = "A map of tags to add to Bucket"
  type        = map(string)
  default     = {}
}

variable "created" {
  description = "Provide a way to generate static ids."
  type        = string
}

variable "region" {
  description = "AWS region to use"
  type        = string
}
