variable "sns_topic_name" {
  description = "Name of the SNS topic for CloudWatch alarm notifications"
  type        = string
}

variable "alert_email" {
  description = "Email address to receive alerts"
  type        = string
}

variable "alarm_name" {
  description = "Name of the CloudWatch Alarm"
  type        = string
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default = ""
}

variable "api_gateway_id" {
  description = "ID of the API Gateway"
  type        = string
  
}

variable "error_threshold" {
  description = "Threshold for triggering alarm"
  type        = number
}

variable "evaluation_periods" {
  description = "Number of periods to evaluate before triggering alarm"
  type        = number
  default     = 1
}

variable "period" {
  description = "The period in seconds over which the metric is evaluated"
  type        = number
  default     = 60
}
