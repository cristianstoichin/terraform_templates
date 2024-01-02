provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}

locals {
  name         = "backend-${replace(basename(path.cwd), "_", "-")}"
  account_name = "account${var.environment == "prod" ? "" : "-"}${var.environment == "prod" ? "" : var.environment}.${var.dns_name}"
  region       = var.region
}

###########################################################
#   Dynamic Data
###########################################################

data "aws_kms_key" "by_alias" {
  key_id = "alias/${var.kms_encryption_key}"
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    SUB-TYPE = "Public"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    SUB-TYPE = "Private"
  }
}

#----------------------------------------------------------
#   Roles
#----------------------------------------------------------

resource "aws_iam_role" "iam_ecs_task_execution_role" {
  name = "${var.application}-role-${var.environment}-${var.created}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags = local.default_tags
}

# Create the ECS Task Role Policy
resource "aws_iam_role_policy" "ecs_task_execution_role" {
  name = "${var.application}-policy-${var.environment}-${var.created}"
  role = aws_iam_role.iam_ecs_task_execution_role.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": [
            "*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "kms:Decrypt",
            "secretsmanager:GetSecretValue"
          ],
          "Resource": [
            "*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage"
          ],
          "Resource": [
            "*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "cloudwatch:DeleteAlarms",
            "cloudwatch:DescribeAlarms",
            "cloudwatch:PutMetricAlarm"
          ],
          "Resource": [
            "*"
          ]
        },
        {
          "Effect": "Allow",
          "Action": [
            "ecs:DescribeServices",
            "ecs:UpdateService"
          ],
          "Resource": [
            "*"
          ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "iam_ecs_task_role" {
  name = "${var.application}-service-role-${var.environment}-${var.created}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  tags = local.default_tags
}

resource "aws_iam_role_policy" "task_execute_command_policy" {
  name   = "${var.application}-policy-${var.environment}-${var.created}"
  role   = aws_iam_role.iam_ecs_task_role.name
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "ecs:ExecuteCommand"
        ],
        "Resource": "${module.cluster.ecs_cluster_arn}"
      },
        {
          "Effect": "Allow",
          "Action": [
            "kms:Decrypt",
            "secretsmanager:GetSecretValue"
          ],
          "Resource": [
            "*"
          ]
        }
    ]
  }
  EOF
}

#----------------------------------------------------------
#   Cert Manager
#----------------------------------------------------------

resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.dns_name}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

#----------------------------------------------------------
#   WEB ACL
#----------------------------------------------------------

# ALB WEB ACL
module "web_acl" {
  source = "../modules/waf-web-acl"
  providers = {
    aws = aws
  }

  application = var.application
  environment = var.environment
  region      = var.region
  created     = var.created
  tags        = local.default_tags
}


#----------------------------------------------------------
#   ALB Infra
#----------------------------------------------------------

module "alb_access_logs_bucket" {
  source = "../modules/lb-logs-bucket"
  providers = {
    aws = aws
  }

  application        = var.application
  kms_encryption_key = data.aws_kms_key.by_alias.arn
  environment        = var.environment
  created            = var.created
  region             = var.region
  tags               = local.default_tags
}

module "alb_security_group" {
  source = "../modules/security-group"
  providers = {
    aws = aws
  }

  name    = "${var.application}-${var.environment}-${var.created}"
  created = var.created
  vpc_id  = var.vpc_id
  tags    = local.default_tags
}

module "alb" {
  source = "../modules/alb"
  depends_on = [
    module.alb_security_group.security_group_id, module.web_acl, aws_acm_certificate.cert, module.alb_access_logs_bucket
  ]
  providers = {
    aws = aws
  }

  application        = var.application
  web_acl_arn        = module.web_acl.web_acl_arn
  bucket             = module.alb_access_logs_bucket.s3_bucket_name
  internal_facing    = false
  environment        = var.environment
  security_group_ids = [module.alb_security_group.security_group_id]
  subnet_ids         = data.aws_subnets.public.ids
  vpc_id             = var.vpc_id
  created            = var.created
  region             = var.region
  tags               = local.default_tags
}

#----------------------------------------------------------
#   Target Group
#----------------------------------------------------------

#Account service
module "target_group" {
  source = "../modules/target-group"
  providers = {
    aws = aws
  }
  name = "account-service-tg"
  # Health check path should be updated when DB schema is initiated.
  # Health checks will fail and container will not start properly otherwise.
  health_check_path   = var.health_check_url
  task_container_port = module.task_definition.task_container_port
  vpc_id              = var.vpc_id
  load_balancer_arn   = module.alb.alb_arn
  created             = var.created
  environment         = var.environment
  cert_arn            = aws_acm_certificate.cert.arn
  depends_on = [
    aws_acm_certificate.cert, module.task_definition, module.alb
  ]
  tags = local.default_tags
}

#----------------------------------------------------------
#   ALB Listeners
#----------------------------------------------------------

#Http to HTTPS Redirect
resource "aws_lb_listener" "http_rule_redirect" {
  load_balancer_arn = module.alb.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    # You can use redirect actions to redirect client requests from one URL to another.
    # You can configure redirects as either temporary (HTTP 302) or permanent (HTTP 301) based on your needs.
    # https://www.terraform.io/docs/providers/aws/r/lb_listener.html#redirect-action
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    module.alb
  ]
}

#Main Listerner rules
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = module.alb.alb_arn

  port     = 443
  protocol = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }

  depends_on = [
    module.alb
  ]
}

resource "aws_lb_listener_rule" "account" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = module.target_group.target_group_arn
  }

  condition {
    host_header {
      values = [local.account_name]
    }
  }
}

#----------------------------------------------------------
#   ECR Repository
#----------------------------------------------------------

#Account Repository
module "repository" {
  source = "../modules/repository"
  providers = {
    aws = aws
  }
  application = "account-service"
  environment = var.environment
  created     = var.created

  tags = local.default_tags
}

#----------------------------------------------------------
#   ECS Cluster
#----------------------------------------------------------

module "cluster" {
  source = "../modules/cluster"
  providers = {
    aws = aws
  }

  application        = var.application
  kms_encryption_key = data.aws_kms_key.by_alias.arn
  environment        = var.environment
  created            = var.created
  log_retention      = var.log_retention

  tags = local.default_tags
}

#----------------------------------------------------------
#   Task Definitions
#----------------------------------------------------------

#Account Service
module "task_definition" {
  source = "../modules/task-definition"
  providers = {
    aws = aws
  }

  cluster_arn             = module.cluster.ecs_cluster_arn
  cpu                     = var.cpu
  memory                  = var.memory
  port_mapping            = var.port_mapping
  task_execution_role_arn = aws_iam_role.iam_ecs_task_execution_role.arn
  task_role_arn           = aws_iam_role.iam_ecs_task_role.arn
  created                 = var.created
  environment             = var.environment
  family_name             = "account-service"
  container_name          = "account-service"
  image_url               = var.initial_image
  log_retention           = var.log_retention

  depends_on = [
    module.alb
  ]

  tags = local.default_tags
}

#----------------------------------------------------------
#   ECS Service
#----------------------------------------------------------

#Account Service
module "task_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"
  providers = {
    aws = aws
  }

  name   = "${var.application}-sec-group-${var.environment}-${var.created}"
  vpc_id = var.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = var.port_mapping
      to_port                  = var.port_mapping
      protocol                 = "tcp"
      description              = "ALB to Container Allowed Port"
      source_security_group_id = module.alb_security_group.security_group_id
    }
  ]
  egress_rules                                             = ["all-all"]
  number_of_computed_ingress_with_source_security_group_id = 1

  tags = local.default_tags
}

#Account Service
module "service" {
  source = "../modules/service"
  providers = {
    aws = aws
  }

  cluster_id                   = module.cluster.ecs_cluster_id
  cluster_name                 = module.cluster.ecs_cluster_name
  service_name                 = "account-service"
  subnet_ids                   = data.aws_subnets.public.ids
  target_group_arn             = module.target_group.target_group_arn
  task_container_name          = module.task_definition.task_container_name
  task_container_port          = module.task_definition.task_container_port
  task_definition_arn          = module.task_definition.task_definition_arn
  task_security_group_ids      = [module.task_security_group.security_group_id]
  memory_scalling_target_value = var.memory_scalling_target_value
  cpu_scalling_target_value    = var.cpu_scalling_target_value
  scale_out_cooldown           = var.scale_out_cooldown
  scale_in_cooldown            = var.scale_in_cooldown
  min_task_count               = var.min_task_count
  max_task_count               = var.max_task_count
  target_group_arn_suffix      = module.target_group.arn_suffix

  created     = var.created
  environment = var.environment
  tags        = local.default_tags

  depends_on = [
    module.task_definition, module.cluster
  ]

}

#----------------------------------------------------------
#   DNS Record Set
#----------------------------------------------------------

#Account DNS name 
resource "aws_route53_record" "cname_record_account" {
  zone_id = var.zone_id
  name    = "account${var.environment == "prod" ? "" : "-"}${var.environment == "prod" ? "" : var.environment}"
  type    = "A"
  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
  depends_on = [
    module.alb
  ]
}
