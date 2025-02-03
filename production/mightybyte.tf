module "mightybyte" {
  source = "../modules/mightybyte"
  resource_tags = var.resource_tags
  aws_region = var.aws_region
  alert_email = var.alert_email
    error_threshold = var.error_threshold

    frontend_bucket_name = var.frontend_bucket_name
    s3_lambda_bucket_name = var.s3_lambda_bucket_name
    sentry_dns = var.sentry_dns

}
