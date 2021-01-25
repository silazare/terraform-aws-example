output "address" {
  description = "Connect to the staging database at this endpoint"
  value       = module.mysql.database_address
}

output "port" {
  description = "The port the staging database is listening on"
  value       = module.mysql.database_port
}
