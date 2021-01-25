variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["user1", "user2", "user3"]
}

variable "give_cloudwatch_full_access" {
  description = "If true, user gets full access to CloudWatch"
  type        = bool
  default     = true
}
