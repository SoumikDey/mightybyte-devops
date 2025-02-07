variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "account_id" {
  type = string
  default = "167814279506"
}
#refer: var.resource_tags["environ"]
variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    environ   = "prod",
    region    = "us-west-2"
    terraform = "true"
  }
}

variable "frontend_bucket_name" {
  type = string
  default = "frontend"
}

variable "s3_lambda_bucket_name" {
  type = string
  default = "lambda-zip"
}

variable "sentry_dns" {
  type = string
  default = "https://e2cb0e563e404581afce29bbce10b790@o4508745391734784.ingest.us.sentry.io/4508745396649984"
}


variable "alert_email" {
  type = string
  default = "soumikdey.fcb@example.com"
}


variable "error_threshold" {
  type = number
  default = 5
}
