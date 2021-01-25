output "address" {
  description = "Connect to the productiondatabase at this endpoint"
  value       = module.mysql.database_address
}

output "port" {
  description = "The port the production database is listening on"
  value       = module.mysql.database_port
}
