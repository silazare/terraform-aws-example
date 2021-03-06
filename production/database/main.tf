module "mysql" {
  source = "../../modules/db-mysql"

  environment            = var.environment
  db_prefix              = var.db_prefix
  db_engine              = "mysql"
  db_storage             = 10
  db_instance_class      = "db.t2.micro"
  db_name                = var.db_name
  db_port                = var.db_port
  db_user_name           = var.db_user_name
  db_publicly_accessible = false

  subnet_ids = data.aws_subnet_ids.custom.ids

  tags = {
    Name        = var.db_name
    Terraform   = "true"
    Environment = "production"
  }
}
