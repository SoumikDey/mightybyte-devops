output "dashboard_name" {
  value = aws_cloudwatch_dashboard.lambda_dashboard.dashboard_name
}

output "dashboard_arn" {
  value = "arn:aws:cloudwatch:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dashboard/${aws_cloudwatch_dashboard.lambda_dashboard.dashboard_name}"
}

output "dashboard_url" {
  value = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.lambda_dashboard.dashboard_name}"
}

output "api_dashboard_name" {
  value = aws_cloudwatch_dashboard.lambda_dashboard.dashboard_name
}

output "api_dashboard_arn" {
  value = "arn:aws:cloudwatch:${var.aws_region}:${data.aws_caller_identity.current.account_id}:dashboard/${aws_cloudwatch_dashboard.lambda_dashboard.dashboard_name}"
}

output "api_dashboard_url" {
  value = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.lambda_dashboard.dashboard_name}"
}
