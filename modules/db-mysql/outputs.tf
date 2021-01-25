output "db_instance_id" {
  description = "Database Instance ID"
  value       = aws_db_instance.this.id
}

output "database_address" {
  description = "Connect to the database at this endpoint"
  value       = aws_db_instance.this.address
}

output "database_port" {
  description = "The port the database is listening on"
  value       = aws_db_instance.this.port
}

output "database_username" {
  value = aws_db_instance.this.username
}

output "database_password" {
  value     = data.aws_ssm_parameter.db_password.value
  sensitive = true
}
