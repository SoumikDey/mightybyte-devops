

locals {
  private_subnet_names = ["private-2a", "private-2b", "private-2c", "private-2d"]
  private_subnets      = ["10.3.64.0/20", "10.3.80.0/20", "10.3.96.0/20", "10.3.112.0/20"]
  public_subnet_names  = ["public-2a", "public-2b", "public-2c", "public-2d"]
  public_subnets       = ["10.3.16.0/20", "10.3.32.0/20", "10.3.48.0/20", "10.3.128.0/20"]
}



module "vpc" {
  source                    = "../vpc"
  name                      = "${var.resource_tags["environ"]}-vpc"
  cidr                      = "10.3.0.0/16"
  azs                       = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
  private_subnets           = local.private_subnets
  private_subnet_names      = [for s in local.private_subnet_names : "${var.resource_tags["environ"]}-${s}"]
  public_subnet_names       = [for s in local.public_subnet_names : "${var.resource_tags["environ"]}-${s}"]
  public_subnets            = local.public_subnets
  enable_nat_gateway        = true
  single_nat_gateway        = true
  enable_flow_log           = false
  map_public_ip_on_launch   = true
  flow_log_destination_type = "s3"
  flow_log_file_format      = "plain-text"
  enable_ipv6               = false
  flow_log_destination_arn  = ""
  tags                      = var.resource_tags
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.resource_tags["environ"]}-private-subnet-group"
  subnet_ids = module.vpc.private_subnets
}
