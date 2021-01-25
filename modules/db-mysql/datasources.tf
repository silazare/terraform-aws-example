// Retrieve RDS Password from SSM Parameter Store
data "aws_ssm_parameter" "db_password" {
  name = "/${var.environment}/${var.db_prefix}-rds/password"

  depends_on = [aws_ssm_parameter.db_password]
}
