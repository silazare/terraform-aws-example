output "alb_dns_name" {
  description = "The domain name of the load balancer"
  value       = module.webserver_example.alb_dns_name
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = module.webserver_example.asg_name
}

output "instance_security_group_id" {
  description = "The ID of the EC2 Instance Security Group"
  value       = module.webserver_example.instance_security_group_id
}
