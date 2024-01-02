variable "cluster_arn" {
  description = "ARN of the ECS cluster that the task will run on"
  type        = string
  default     = null
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

variable "task_execution_role_arn" {
  description = "Provide task def role."
  type        = string
}

variable "task_role_arn" {
  description = "Provide task def role."
  type        = string
}

variable "tags" {
  description = "A map of tags to add"
  type        = map(string)
  default     = {}
}

variable "container_name" {
  type        = string
  default     = null
}

variable "family_name" {
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

variable "image_url" {
  description = "Task def image url."
  type        = string
}

variable "log_retention" {
  type        = number
}