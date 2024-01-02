variable "vpc_id" {
  description = "The VPC ID that the ALB should be associated with"
  type        = string
  default     = null
}

variable "name" {
  description = "name of VPC"
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