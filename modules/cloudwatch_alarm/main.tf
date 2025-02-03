resource "aws_sns_topic" "alarm_topic" {
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "api_gateway_5xx_alarm" {
  alarm_name          = var.alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "5xx"
  namespace           = "AWS/ApiGateway"
  period             = var.period
  statistic          = "Sum"
  threshold         = var.error_threshold
  alarm_description = "Triggers when 5XX errors exceed ${var.error_threshold}"
  treat_missing_data = "notBreaching"

  dimensions = {
    Stage = "prod"
    ApiId = var.api_gateway_id
  }

  actions_enabled = true
  alarm_actions   = [aws_sns_topic.alarm_topic.arn]
}
