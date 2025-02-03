
resource "aws_db_parameter_group" "default" {
  name   = "${var.database_server_name}-pg"
  family = var.db_parameter_group_family

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }


}

resource "aws_security_group" "rds_sg" {
  name        = "${var.database_server_name}-sg"
  description = "${var.database_server_name}-sg-for-rds"
  vpc_id      = var.vpc_id

  # Inbound Rules (allow all inbound traffic)
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  # Outbound Rules (allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Open to all IPs
  }
  tags = {
    Name = "${var.database_server_name}-sg"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage               = var.allocated_storage
  max_allocated_storage           = var.max_allocated_storage
  identifier                      = var.database_server_name
  db_name                         = var.initial_database_name
  engine                          = var.database_engine
  engine_version                  = var.database_engine_version
  availability_zone               = var.availability_zone
  instance_class                  = var.db_instance_type
  username                        = var.username
  manage_master_user_password     = true
  parameter_group_name            = aws_db_parameter_group.default.name
  skip_final_snapshot             = true
  allow_major_version_upgrade     = true
  apply_immediately               = true
  db_subnet_group_name            = var.db_subnet_group_name
  storage_type                    = "gp3"
  publicly_accessible             = false
  vpc_security_group_ids          = [aws_security_group.rds_sg.id]
  backup_retention_period         = 30
  deletion_protection             = var.deletion_protection
  multi_az                        = var.multi_az
  storage_encrypted               = true
  enabled_cloudwatch_logs_exports = var.log_exports

}

