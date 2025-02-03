module "lambda" {
  source               = "../lambda_inside_vpc"
  vpc_id               = module.vpc.vpc_id
  lambda_function_name = "${var.resource_tags["environ"]}-lambda"
  filename             = "lambda_function.zip"
  runtime              = "python3.12"
  handler              = "lambda_function.lambda_handler"
  aws_region           = var.aws_region
  resource_tags        = var.resource_tags
  subnet_ids           = module.vpc.private_subnets
  timeout              = 100
  account_id           = var.account_id
  lambda_layers        = [aws_lambda_layer_version.lambda_layer.arn]
  environment_variables = {
    DB_HOST     = module.rds-postgres.db_host
    DB_NAME     = "taskdb"
    SECRET_NAME = module.rds-postgres.secret
    REGION      = var.aws_region
    SENTRY_DSN  = var.sentry_dns
  }
}

