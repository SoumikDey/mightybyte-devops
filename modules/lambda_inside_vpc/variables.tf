variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
variable "vpc_id" {
  default = ""
}
variable "lambda_function_name" {
  default = ""
}
variable "filename" {
  default = ""
}

variable "runtime" {
  default = ""
}

variable "handler" {
  default = ""
}


variable "environment_variables" {
  type = map(string)
}

variable "aws_region" {
  type    = string
  default = ""
}

variable "timeout" {
  default = 0
  type = number

}

variable "resource_tags" {
  default = ""
}

variable "subnet_ids" {
  default = ""
}

variable "lambda_layers" {
  type    = list(string)
  default = []
}

variable "account_id" {
  default = ""
  type = string

}
