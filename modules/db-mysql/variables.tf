# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "The environment to use for the database"
  type        = string
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
}

variable "db_prefix" {
  description = "The prefix name to use for the database"
  type        = string
}

variable "db_engine" {
  description = "The engine to use for the database"
  type        = string
}

variable "db_storage" {
  description = "The storage size for the database"
  type        = number
}

variable "db_instance_class" {
  description = "The type of RDS instances to run"
  type        = string
}

variable "db_port" {
  description = "Port which the database should run on"
  type        = number
}

variable "db_user_name" {
  description = "The username for the database"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy to"
  type        = list(string)
}

variable "db_publicly_accessible" {
  description = "Control if instance is publicly accessible"
  type        = bool
  default     = false
}
