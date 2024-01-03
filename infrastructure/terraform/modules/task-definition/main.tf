data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  log_group_name = "/${var.container_name}-${var.environment}-${var.created}"
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = local.log_group_name
  retention_in_days = var.log_retention
}

# Creating a custom cloudwatch log metric filter to capture status code 5xx errors and throw them into the cloudwatch metrics.
# Using this custom cloudwatch metric we can then setup a cloudwatch alarm to monitor those 5xx errors. 
resource "aws_cloudwatch_log_metric_filter" "http_5xx_errors" {
  name           = "Http5xxMetricFilter"
  pattern        = "{ $.StatusCode = 5** }"
  log_group_name = local.log_group_name

  metric_transformation {
    name      = "Http5xx_count_${var.environment}"
    namespace = "MerchandisingSchedulerNamespace"
    value     = "1"
  }

  depends_on      = [aws_cloudwatch_log_group.ecs_log_group]
}

# Creating this custom cloudwatch log metric filter to capture the status code 2xx and put them into the cloudwatch metrics. 
# This will help us compare the 2xx vs 5xx and create alarms based on a percentage of failures. 
resource "aws_cloudwatch_log_metric_filter" "http_2xx_count" {
  name           = "Http2xxMetricFilter"
  pattern        = "{ $.StatusCode = 2** }"
  log_group_name = local.log_group_name

  metric_transformation {
    name      = "Http2xx_count_${var.environment}"
    namespace = "MerchandisingSchedulerNamespace"
    value     = "1"
  }

   depends_on      = [aws_cloudwatch_log_group.ecs_log_group]
}

# Creating this custom cloudwatch log metric filter to capture the status code 4xx and put them into the cloudwatch metrics. 
# This will help us compare the 2xx vs 4xx vs 5xx and create a cloudwatch dashboard for visual purpose. 
resource "aws_cloudwatch_log_metric_filter" "http_4xx_count" {
  name           = "Http4xxMetricFilter"
  pattern        = "{ $.StatusCode = 4** }"
  log_group_name = local.log_group_name

  metric_transformation {
    name      = "Http4xx_count_${var.environment}"
    namespace = "MerchandisingSchedulerNamespace"
    value     = "1"
  }

   depends_on      = [aws_cloudwatch_log_group.ecs_log_group]
}

#------------------------------------------------------------------------------
# ECS Service and task definition
#------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "this" {
  family = "${var.family_name}-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = "${var.task_execution_role_arn}"
  task_role_arn      = var.task_role_arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "${var.container_name}-${var.environment}",
    "image": "${var.image_url}",
    "portMappings": [
        {
            "containerPort": ${var.port_mapping}
        }
    ],
    "logConfiguration": { 
        "logDriver": "awslogs",
        "options": { 
            "awslogs-group":  "${local.log_group_name}",
            "awslogs-region": "${data.aws_region.current.name}",
            "awslogs-stream-prefix": "ecs"
        }
    },
    "essential": true
  }
]
TASK_DEFINITION

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
