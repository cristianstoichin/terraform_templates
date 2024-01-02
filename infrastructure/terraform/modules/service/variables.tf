variable "cluster_id" {
  description = "ID of the ECS cluster that the task will run on"
  type        = string
  default     = null
}
variable "service_name" {
  description = "Service name to use and append to the resource names"
  type        = string
}

variable "cluster_name" {
  description = "ID of the ECS cluster that the task will run on"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "The list of subnets that the service should run in"
  type        = list(string)
  default     = null
}

variable "target_group_arn" {
  description = "ARN of the target group to associate with for load balancing"
  type        = string
  default     = null
}

variable "task_container_name" {
  description = "Name of the container that is within the task definition"
  type        = string
  default     = "app"
}

variable "task_container_port" {
  description = "The port that is mapped to access the container"
  type        = number
  default     = 3000
}

variable "task_definition_arn" {
  description = "ARN of the desired task definition"
  type        = string
  default     = null
}

variable "task_security_group_ids" {
  description = "The list of security group IDs that the service should attach to tasks"
  type        = list(string)
  default     = null
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

variable "min_task_count" {
  description = "Minimum task count."
  type        = string
}

variable "max_task_count" {
  description = "Max task count."
  type        = string
}

variable "target_group_arn_suffix" {
  description = "Target Group ARN Name."
  type        = string
}

variable "memory_scalling_target_value" {
  description = "Memory scalling policy threshold."
  type        = number
  default = 70
}

variable "cpu_scalling_target_value" {
  description = "CPU scalling policy threshold."
  type        = number
  default = 70
}

variable "scale_out_cooldown" {
  description = "The amount of time, in seconds, after a scale out activity completes before another scale out activity can start."
  type        = number
  default = 60
}

variable "scale_in_cooldown" {
  description = "The amount of time, in seconds, after a scale in activity completes before another scale in activity can start."
  type        = number
  default = 600
}
