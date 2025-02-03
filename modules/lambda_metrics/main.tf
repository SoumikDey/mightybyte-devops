data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_dashboard" "lambda_dashboard" {
  dashboard_name = var.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          title = "Lambda Invocations"
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name]
          ]
          region = var.aws_region
          period = 60
        }
      },
      {
        type = "metric"
        properties = {
          title = "Lambda Errors"
          metrics = [
            ["AWS/Lambda", "Errors", "FunctionName", var.lambda_function_name]
          ]
          region = var.aws_region
          period = 60
        }
      },
      {
        type = "metric"
        properties = {
          title = "Lambda Duration"
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", var.lambda_function_name]
          ]
          region = var.aws_region
          period = 60
        }
      },
      {
        type = "metric"
        properties = {
          title = "Lambda Throttles"
          metrics = [
            ["AWS/Lambda", "Throttles", "FunctionName", var.lambda_function_name]
          ]
          region = var.aws_region
          period = 60
        }
      },
      {
        type = "metric"
        properties = {
          title = "API Gateway Requests"
          metrics = [
            ["AWS/ApiGateway", "Count", "ApiId", var.api_gateway_id]
          ]
          region = var.aws_region
          period = 60
        }
      },
      {
        type = "metric"
        properties = {
          title = "API Gateway Latency"
          metrics = [
            ["AWS/ApiGateway", "Latency", "ApiId", var.api_gateway_id]
          ]
          region = var.aws_region
          period = 60
        }
      },
      {
        type = "metric"
        properties = {
          title = "API Gateway 4XX Errors"
          metrics = [
            ["AWS/ApiGateway", "4xx", "ApiId", var.api_gateway_id]
          ]
          region = var.aws_region
          period = 60
        }
      },
      {
        type = "metric"
        properties = {
          title = "API Gateway 5XX Errors"
          metrics = [
            ["AWS/ApiGateway", "5xx", "ApiId", var.api_gateway_id]
          ]
          region = var.aws_region
          period = 60
        }
      },
      
    ]
  })
}
