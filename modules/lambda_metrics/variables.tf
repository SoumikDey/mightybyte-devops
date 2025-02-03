variable "lambda_function_name" {
    description = "The name of the Lambda function"
    type        = string
}
variable "error_threshold" {
    description = "The error threshold for the CloudWatch alarm"
    type        = number
}
variable "alarm_name" {
    description = "The name of the CloudWatch alarm"
    type        = string
}




variable "api_gateway_name" {
  description = "The name of the API Gateway"
  type        = string
  default = ""
}

variable "api_gateway_id" {
  description = "The name of the API Gateway"
  type        = string
}

variable "dashboard_name" {
  description = "The name of the CloudWatch dashboard"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}
