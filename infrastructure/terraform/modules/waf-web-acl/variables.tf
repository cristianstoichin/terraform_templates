variable "tags" {
  description = "A map of tags to add"
  type        = map(string)
  default     = {}
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

variable "created" {
  description = "Provide a way to generate static ids."
  type        = string
}


variable "region" {
  description = "Region"
  type        = string
  default     = null
}