variable "application" {
  description = "Application name to use and append to the resource names"
  type        = string
}

variable "environment" {
  description = "Environment to be added on all the resources to the identifier"
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