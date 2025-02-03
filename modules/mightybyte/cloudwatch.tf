
module "lambda_metrics" { 
  source               = "../lambda_metrics"
  lambda_function_name = module.lambda.name
  error_threshold      = 5
  alarm_name           = "${module.lambda.name}-error-alarm"
  dashboard_name       = "${module.lambda.name}-dashboard"
  aws_region           = var.aws_region
  api_gateway_name     = "${var.resource_tags["environ"]}-api-gateway"
  api_gateway_id = aws_apigatewayv2_api.main.id
}
module "cloudwatch_alarm" {
  source           = "../cloudwatch_alarm"
  sns_topic_name   = "api-gateway-error-alerts"
  alert_email      = var.alert_email
  alarm_name       = "APIGateway5xxErrorAlarm"
  api_gateway_name = "${var.resource_tags["environ"]}-api-gateway"
  api_gateway_id   =   aws_apigatewayv2_api.main.id
  error_threshold  = var.error_threshold
  evaluation_periods = 2
  period = 60
}

