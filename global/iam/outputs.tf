output "user_arns" {
  description = "The ARNs for all users"
  value       = values(aws_iam_user.example)[*].arn
}
