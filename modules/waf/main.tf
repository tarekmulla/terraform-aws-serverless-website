resource "aws_wafv2_web_acl" "web_acl" {
  name        = "${var.app}-${terraform.workspace}-acl"
  description = "AWS Managed Rules for WAF"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  # General rules, including those listed in OWASP, CVE, etc.
  rule {
    name     = "${var.app}-${terraform.workspace}-rule-common"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app}-${terraform.workspace}-rule-common-metric"
      sampled_requests_enabled   = true
    }
  }

  # block request patterns associated with exploitation of SQL databases, like SQL injection
  rule {
    name     = "${var.app}-${terraform.workspace}-rule-sql"
    priority = 2

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
      metric_name                = "${var.app}-${terraform.workspace}-rule-sql-metric"
      sampled_requests_enabled   = true
    }
  }

  # block request patterns associated with the exploitation of vulnerabilities specific to Linux,
  # including Linux-specific Local File Inclusion (LFI) attacks
  rule {
    name     = "${var.app}-${terraform.workspace}-rule-linux"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app}-${terraform.workspace}-rule-linux-metric"
      sampled_requests_enabled   = true
    }
  }

  # block request patterns associated with the exploitation of vulnerabilities specific to POSIX and
  # POSIX-like operating systems, including Local File Inclusion (LFI) attacks
  rule {
    name     = "${var.app}-${terraform.workspace}-rule-posix"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesUnixRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.app}-${terraform.workspace}-rule-posix-metric"
      sampled_requests_enabled   = true
    }
  }

  tags     = var.tags
  tags_all = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.app}-${terraform.workspace}-web-acl"
    sampled_requests_enabled   = true
  }
}
