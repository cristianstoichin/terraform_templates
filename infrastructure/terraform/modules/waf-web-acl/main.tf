#--------------------------------------------------------------------------------
## WAF WEB Acl
#--------------------------------------------------------------------------------

resource "aws_wafv2_web_acl" "wafv2_web_acl" {
  name        = "${var.application}-AWS-WAF2-${var.region}-${var.environment}"
  description = "WAF rules for ${var.environment} in ${var.region}"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "SelfManagedRulesBlanketHTTPFlood"
    priority = 0

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 6000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SelfManagedRulesBlanketHTTPFlood"
      sampled_requests_enabled   = false
    }

  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        
        rule_action_override {
          action_to_use {
            count {}
          }

          name = "SizeRestrictions_BODY"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "GenericRFI_BODY"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "GenericLFI_BODY"
        }
        
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }

  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }

  }

  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }

  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }

  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AWSManagedRules"
    sampled_requests_enabled   = true
  }

  tags = var.tags
}

//WAFv2 logging
resource "aws_cloudwatch_log_group" "wafv2_log_group" {
  name              = "aws-waf-logs-${var.application}-${var.environment}"
  retention_in_days = 90
}

resource "aws_wafv2_web_acl_logging_configuration" "wafv2_logging_config" {
  log_destination_configs = [aws_cloudwatch_log_group.wafv2_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.wafv2_web_acl.arn
}