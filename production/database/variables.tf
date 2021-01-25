# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_remote_state_bucket" {
  description = "The name of the S3 bucket used for the VPC remote state storage"
  type        = string
}

variable "vpc_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the VPC remote state storage"
  type        = string
}

variable "vpc_remote_state_region" {
  description = "The region of S3 bucket used for the VPC remote state storage"
  type        = string
}

variable "vpc_dynamodb_table" {
  description = "The DynamoDB table used for the database's remote state lock"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "environment" {
  description = "The environment to use for the database"
  type        = string
  default     = "production"
}

variable "db_prefix" {
  description = "The prefix name of the DB"
  type        = string
  default     = "production"
}

variable "db_name" {
  description = "The name of the DB"
  type        = string
  default     = "production"
}

variable "db_port" {
  description = "Port which the database should run on"
  type        = number
  default     = 3306
}

variable "db_user_name" {
  description = "The username for the staging database"
  type        = string
  default     = "admin"
}
