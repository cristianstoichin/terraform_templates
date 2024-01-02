data "aws_elb_service_account" "main" {}

# S3 bucket to store all the ALB Access logs
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket =  "${var.application}-${var.region}-${var.environment}-${var.created}-access"
  policy = data.aws_iam_policy_document.lb_log_delivery.json
}

# Declare IAM policy for the S3 permission. Only allow the ALB Arn to write to that Bucket.
data "aws_iam_policy_document" "lb_log_delivery" {

  statement {
    sid    = "AWSLogDeliveryELBAccount"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
    }
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${var.application}-${var.region}-${var.environment}-${var.created}-access/alb-logs/*",
    ]
  }

  statement {
    sid = "AWSLogDeliveryWrite"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${var.application}-${var.region}-${var.environment}-${var.created}-access/alb-logs/*",
    ]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      "arn:aws:s3:::${var.application}-${var.region}-${var.environment}-${var.created}-access",
    ]
  }
}

resource "aws_lb" "this" {
  name        = "${var.application}-${var.environment}"
  internal           = var.internal_facing
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids

  access_logs {
    bucket  = "${var.application}-${var.region}-${var.environment}-${var.created}-access"
    prefix  = "alb-logs"
    enabled = true
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }

}


#--------------------------------------------------------------------------------
## AWS Advanced Shield enabled
#--------------------------------------------------------------------------------

### IMPORTANT - Account must have shield advanced enabled first
# ALB 
#resource "aws_shield_protection" "load_balancer" {
#  name         = "${var.application}-${var.region}-${var.environment}-${var.created}"
#  resource_arn = aws_lb.this.arn

#  tags = var.tags
#}

#--------------------------------------------------------------------------------
## WAF WEB Acl
#--------------------------------------------------------------------------------

resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = aws_lb.this.arn
  web_acl_arn  = "${var.web_acl_arn}"
}