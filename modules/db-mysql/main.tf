resource "aws_db_subnet_group" "this" {
  name       = "${var.db_prefix}-${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(var.tags)
}

resource "aws_db_instance" "this" {
  identifier_prefix    = "${var.db_prefix}-"
  engine               = var.db_engine
  allocated_storage    = var.db_storage
  instance_class       = var.db_instance_class
  name                 = var.db_name
  port                 = var.db_port
  username             = var.db_user_name
  password             = data.aws_ssm_parameter.db_password.value
  skip_final_snapshot  = true
  publicly_accessible  = var.db_publicly_accessible
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = merge(var.tags)

}

// Generate RDS Password
resource "random_password" "this" {
  length           = 20
  special          = true
  override_special = "#!()_"
}

// Store RDS Password in SSM Parameter Store
resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.environment}/${var.db_prefix}-rds/password"
  description = "Master Password for ${var.db_prefix} RDS Database"
  type        = "SecureString"
  value       = random_password.this.result
}
