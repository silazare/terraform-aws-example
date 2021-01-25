output "db_instance_id" {
  description = "Database Instance ID"
  value       = module.database_example.db_instance_id
}

output "address" {
  description = "Connect to the staging database at this endpoint"
  value       = module.database_example.database_address
}

output "port" {
  description = "The port the staging database is listening on"
  value       = module.database_example.database_port
}
