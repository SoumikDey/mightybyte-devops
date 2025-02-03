variable "db_parameters" {
  description = "Map of custom DB parameters"
  type        = map(string)
  default     = {}
}


variable "database_server_name" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "db_parameter_group_family" {
  default = ""
}
variable "database_engine" {
  default = ""
}
variable "database_engine_version" {
  default = ""
}
variable "db_instance_type" {
  default = "db.t3.micro"
}
variable "initial_database_name" {
  default = "postgres-initial-db"
}
variable "multi_az" {
  default = false
}
variable "allocated_storage" {
  default = 20
}
variable "max_allocated_storage" {
  default = 100
}
variable "db_subnet_group_name" {
  default = ""
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

variable "username" {
  default = ""
}

# variable "password" {
#   default = ""
# }

variable "deletion_protection" {
  default = false
}

variable "availability_zone" {
  default = ""
}

variable "log_exports" {
  default = ""
}
