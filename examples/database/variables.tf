# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "The environment to use for the database"
  type        = string
  default     = "default"
}

variable "db_prefix" {
  description = "The prefix name of the DB"
  type        = string
  default     = "test"
}

variable "db_name" {
  description = "The name of the DB"
  type        = string
  default     = "test"
}

variable "db_port" {
  description = "Port which the database should run on"
  type        = number
  default     = 3306
}

variable "db_user_name" {
  description = "The DB username"
  type        = string
  default     = "admin"
}
