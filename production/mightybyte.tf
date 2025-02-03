module "mightybyte" {
  source          = "../modules/mightybyte"
  resource_tags   = var.resource_tags
  aws_region      = var.aws_region
  alert_email     = var.alert_email
  error_threshold = var.error_threshold
  sentry_dns      = var.sentry_dns

}
