data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "monitoring_dashboard" {
  dashboard_name = "${var.app}-${terraform.workspace}-dashboard"

  dashboard_body = <<EOF
{
    "start": "-PT168H",
    "widgets": [
        {
            "height": 5,
            "width": 7,
            "y": 0,
            "x": 17,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApiGateway", "Latency", "ApiName", "${var.api_name}", { "region": "${data.aws_region.current.name}" } ],
                    [ "AWS/ApiGateway", "IntegrationLatency", "ApiName", "${var.api_name}", { "region": "${data.aws_region.current.name}" } ]
                ],
                "sparkline": false,
                "view": "gauge",
                "region": "${data.aws_region.current.name}",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 5000
                    }
                },
                "setPeriodToTimeRange": true,
                "trend": false,
                "liveData": false,
                "period": 300,
                "stat": "Average",
                "title": "API Gateway",
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 3,
            "width": 11,
            "y": 3,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApiGateway", "Count", "ApiName", "${var.api_name}", { "label": "All calls" } ],
                    [ ".", "4XXError", ".", ".", { "region": "${data.aws_region.current.name}" } ],
                    [ ".", "5XXError", ".", "." ]
                ],
                "view": "singleValue",
                "region": "${data.aws_region.current.name}",
                "stat": "Sum",
                "period": 300,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                },
                "setPeriodToTimeRange": true,
                "sparkline": false,
                "trend": false,
                "singleValueFullPrecision": true,
                "stacked": false,
                "title": "API Gateway"
            }
        },
        {
            "height": 10,
            "width": 7,
            "y": 5,
            "x": 17,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApiGateway", "Latency", "ApiName", "${var.api_name}", { "region": "${data.aws_region.current.name}" } ],
                    [ ".", "IntegrationLatency", ".", ".", { "region": "${data.aws_region.current.name}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${data.aws_region.current.name}",
                "setPeriodToTimeRange": true,
                "stat": "Average",
                "period": 300,
                "title": "API Gateway"
            }
        },
        {
            "height": 3,
            "width": 2,
            "y": 12,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/S3", "BucketSizeBytes", "StorageType", "StandardStorage", "BucketName", "${var.bucket_name}", { "label": "Data size", "region": "${data.aws_region.current.name}" } ]
                ],
                "sparkline": false,
                "view": "singleValue",
                "region": "${data.aws_region.current.name}",
                "stat": "Maximum",
                "period": 2592000,
                "title": "S3 Bucket",
                "setPeriodToTimeRange": false,
                "trend": true,
                "liveData": false,
                "singleValueFullPrecision": false
            }
        },
        {
            "height": 3,
            "width": 2,
            "y": 12,
            "x": 2,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SES", "Send", { "label": "Email Sent", "region": "${data.aws_region.current.name}" } ]
                ],
                "sparkline": false,
                "view": "singleValue",
                "region": "${data.aws_region.current.name}",
                "title": "SES Email",
                "period": 2592000,
                "stat": "Sum",
                "stacked": false,
                "setPeriodToTimeRange": true,
                "trend": false
            }
        },
        {
            "height": 3,
            "width": 11,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/CloudFront", "Requests", "Region", "Global", "DistributionId", "${var.cloudfront_dist_id}", { "region": "${data.aws_region.current.name}", "stat": "Sum", "label": "Requests number" } ],
                    [ ".", "4xxErrorRate", ".", ".", ".", ".", { "region": "${data.aws_region.current.name}" } ],
                    [ ".", "5xxErrorRate", ".", ".", ".", ".", { "region": "${data.aws_region.current.name}" } ]
                ],
                "view": "singleValue",
                "region": "${data.aws_region.current.name}",
                "stat": "Average",
                "period": 300,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 1000
                    }
                },
                "setPeriodToTimeRange": true,
                "sparkline": false,
                "trend": false,
                "singleValueFullPrecision": false,
                "liveData": false,
                "title": "Cloudfront"
            }
        },
        {
            "height": 3,
            "width": 6,
            "y": 6,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/WAFV2", "AllowedRequests", "WebACL", "${var.waf_name}", "Rule", "ALL", { "label": "Allowed", "region": "${data.aws_region.current.name}" } ],
                    [ "AWS/WAFV2", "BlockedRequests", "WebACL", "${var.waf_name}", "Rule", "ALL", { "label": "Blocked", "region": "${data.aws_region.current.name}" } ]
                ],
                "view": "singleValue",
                "stacked": false,
                "region": "${data.aws_region.current.name}",
                "stat": "Sum",
                "period": 300,
                "setPeriodToTimeRange": true,
                "sparkline": false,
                "trend": false,
                "title": "Web application firewall"
            }
        },
        {
            "height": 5,
            "width": 6,
            "y": 10,
            "x": 11,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Invocations", "FunctionName", "${var.lambda_authorizer_name}", { "region": "${data.aws_region.current.name}" } ],
                    [ ".", "Duration", ".", ".", { "region": "${data.aws_region.current.name}", "stat": "Average" } ],
                    [ ".", "Throttles", ".", "." ],
                    [ ".", "Errors", ".", "." ]
                ],
                "sparkline": false,
                "view": "singleValue",
                "region": "${data.aws_region.current.name}",
                "stat": "Sum",
                "period": 300,
                "setPeriodToTimeRange": true,
                "trend": false,
                "title": "Authorizer lambda",
                "liveData": false
            }
        },
        {
            "height": 5,
            "width": 6,
            "y": 5,
            "x": 11,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Invocations", "FunctionName", "${var.lambda_contact_name}", { "stat": "Sum", "region": "${data.aws_region.current.name}" } ],
                    [ ".", "Duration", ".", ".", { "region": "${data.aws_region.current.name}" } ],
                    [ ".", "Throttles", ".", ".", { "region": "${data.aws_region.current.name}" } ],
                    [ ".", "Errors", ".", ".", { "region": "${data.aws_region.current.name}" } ]
                ],
                "sparkline": false,
                "view": "singleValue",
                "region": "${data.aws_region.current.name}",
                "stat": "Average",
                "period": 300,
                "setPeriodToTimeRange": true,
                "trend": false,
                "title": "Contact lambda",
                "liveData": false
            }
        },
        {
            "height": 3,
            "width": 2,
            "y": 12,
            "x": 4,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/CertificateManager", "DaysToExpiry", "CertificateArn", "arn:aws:acm:${data.aws_region.current.name}:836049003243:certificate/c722727d-9acd-44c8-a14a-f1478f434369", { "region": "${data.aws_region.current.name}" } ]
                ],
                "sparkline": false,
                "view": "singleValue",
                "region": "${data.aws_region.current.name}",
                "title": "Certificate",
                "stat": "Minimum",
                "period": 300,
                "liveData": false
            }
        },
        {
            "height": 5,
            "width": 6,
            "y": 0,
            "x": 11,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Invocations", "FunctionName", "${var.lambda_authorizer_name}", { "label": "authorizer", "region": "${data.aws_region.current.name}" } ],
                    [ "AWS/Lambda", "Invocations", "FunctionName", "${var.lambda_contact_name}", { "label": "contact", "region": "${data.aws_region.current.name}" } ]
                ],
                "view": "pie",
                "region": "${data.aws_region.current.name}",
                "stat": "Sum",
                "period": 300,
                "setPeriodToTimeRange": true,
                "sparkline": false,
                "trend": false,
                "legend": {
                    "position": "right"
                },
                "labels": {
                    "visible": false
                },
                "liveData": false,
                "title": "Lmabda invocation"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 6,
            "width": 5,
            "height": 9,
            "properties": {
                "metrics": [
                    [ "AWS/WAFV2", "BlockedRequests", "WebACL", "${var.waf_name}", "Rule", "${var.app}-${terraform.workspace}-rule-common-metric", { "label": "Core", "region": "${data.aws_region.current.name}" } ],
                    [ "...", "${var.app}-${terraform.workspace}-rule-linux-metric", { "label": "Linux", "region": "${data.aws_region.current.name}" } ],
                    [ "...", "${var.app}-${terraform.workspace}-rule-posix-metric", { "label": "POSIX", "region": "${data.aws_region.current.name}" } ],
                    [ "...", "${var.app}-${terraform.workspace}-rule-sql-metric", { "label": "SQL", "region": "${data.aws_region.current.name}" } ]
                ],
                "view": "pie",
                "region": "${data.aws_region.current.name}",
                "stat": "Sum",
                "period": 300,
                "setPeriodToTimeRange": true,
                "sparkline": false,
                "trend": false,
                "stacked": false,
                "legend": {
                    "position": "bottom"
                },
                "labels": {
                    "visible": false
                },
                "title": "WAF Blocked Requests"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 9,
            "width": 6,
            "height": 3,
            "properties": {
                "metrics": [
                    [ "AWS/WAFV2", "SampleAllowedRequest", "WebACL", "${var.waf_name}", "BotCategory", "bot:category:social_media", { "label": "Social media" } ],
                    [ "...", "bot:category:search_engine", { "label": "Search engine" } ]
                ],
                "sparkline": false,
                "view": "singleValue",
                "region": "${data.aws_region.current.name}",
                "setPeriodToTimeRange": true,
                "trend": false,
                "stat": "Sum",
                "period": 300,
                "title": "Bot detection"
            }
        }
    ]
}
EOF
}
