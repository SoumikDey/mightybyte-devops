output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}


output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "jumpbox_public_ip" {
  description = "Jumpbox public IP"
  value       = module.jumpbox.public_ip
}

output "db_host" {
  value = module.rds-postgres.db_host
}

output "secret_name" {
  value = module.rds-postgres.secret
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudwatch_dashboard_url" {
  value = module.lambda_metrics.dashboard_url
}


output "api_gateway_url" {
  value = "${aws_apigatewayv2_stage.prod.invoke_url}/tasks" 
}

output "s3_frontend_bucket" {
  value = module.s3-frontend.s3_bucket_id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}