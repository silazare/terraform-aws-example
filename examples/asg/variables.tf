# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the ASG and all its resources"
  type        = string
  default     = "test"
}

variable "alb_security_group" {
  description = "ALB Security Group ID mock"
  type        = string
  default     = null
}
