# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the ASG and all its resources"
  type        = string
  default     = "test"
}

variable "environment" {
  description = "The name of the environment we're deploying to"
  type        = string
  default     = "default"
}

variable "db_address" {
  description = "The DB address"
  type        = string
  default     = "localhost"
}

variable "db_port" {
  description = "The DB port"
  type        = number
  default     = 3306
}

variable "server_text" {
  description = "The text the web server should return"
  type        = string
  default     = "webserver test"
}
