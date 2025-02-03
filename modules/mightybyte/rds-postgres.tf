module "rds-postgres" {
  source        = "../databases"
  db_parameters = {}

  database_server_name      = "${var.resource_tags["environ"]}-postgres"
  vpc_id                    = module.vpc.vpc_id
  db_subnet_group_name      = "${var.resource_tags["environ"]}-private-subnet-group"
  username                  = "postgres_admin"
  db_parameter_group_family = "postgres16"
  database_engine           = "postgres"
  database_engine_version   = "16.3"
  availability_zone         = "us-west-2a"
  db_instance_type          = "db.t3.micro"
  initial_database_name     = "postgres"
  multi_az                  = false
  deletion_protection       = false
  allocated_storage         = 25
  max_allocated_storage     = 25
  log_exports               = ["postgresql", "upgrade"]
  ingress_rules = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
