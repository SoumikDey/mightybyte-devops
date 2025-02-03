variable "resource_tags" {
  type = map(string)
  default = {

  }
}
variable "instance_name" {
  default = ""
}
variable "ami" {
  type    = string
  default = "" # Empty default means it will fallback to data source
}


variable "instance_type" {
  default = ""
}
variable "key_name" {
  default = ""
}

variable "monitoring" {
  default = false
}
variable "subnet_id" {
  default = ""
}

variable "create_eip" {
  default = true
}
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

variable "create_iam_instance_profile" {
  default = true
}

variable "iam_role_policies" {
  type = map(string)
  default = {
    ssmAccess = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
