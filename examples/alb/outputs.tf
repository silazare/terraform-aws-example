output "alb_dns_name" {
  value       = module.alb_example.alb_dns_name
  description = "The domain name of the load balancer"
}
