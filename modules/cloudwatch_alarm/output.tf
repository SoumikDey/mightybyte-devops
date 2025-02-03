output "sns_topic_arn" {
  value = aws_sns_topic.alarm_topic.arn
}

output "cloudwatch_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.api_gateway_5xx_alarm.arn
}
