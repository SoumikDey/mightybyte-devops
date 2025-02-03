output "jumpbox_public_ip" {
  description = "Jumpbox public IP"
  value       = module.mightybyte.jumpbox_public_ip
}

output "db_host" {
  description = "value of the db_host"
  value       = module.mightybyte.db_host
}

output "cloudfront_url" {
  description = "value of the cloudfront_url"
  value       = module.mightybyte.cloudfront_url
}

output "api_gateway_url" {
  description = "value of the api_gateway_url"
  value       = module.mightybyte.api_gateway_url
}

output "cloudwatch_dashboard_url" {
  description = "value of the cloudwatch_dashboard_url"
  value       = module.mightybyte.cloudwatch_dashboard_url
}

output "s3_frontend_bucket" {
  description = "value of the s3_frontend_bucket"
  value       = module.mightybyte.s3_frontend_bucket
  
}

output "cloudfront_distribution_id" {
  description = "value of the cloudfront_distribution_id"
  value       = module.mightybyte.cloudfront_distribution_id
}