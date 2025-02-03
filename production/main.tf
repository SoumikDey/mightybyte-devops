terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.11"
    }
  }
  required_version = ">= 1.5.0"

  
  # backend "s3" {
  #   bucket         = "${var.resource_tags["environ"]}-remote-backend"
  #   key            = "mightybyte/terraform.tfstate"
  #   region         = var.aws_region
  #   encrypt        = true
  #   profile        = "ajastos"
  # }
}

provider "aws" {
  region = var.aws_region
  profile = "ajastos"
}
