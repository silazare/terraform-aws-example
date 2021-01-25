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
  description = "The DynamoDB table used for VPC remote state lock"
  type        = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
}

variable "db_remote_state_region" {
  description = "The region of S3 bucket used for the database's remote state storage"
  type        = string
}

variable "db_dynamodb_table" {
  description = "The DynamoDB table used for the database's remote state lock"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webserver"
}

variable "environment" {
  description = "The name of the environment we're deploying to"
  type        = string
  default     = "production"
}

variable "server_text" {
  description = "The text the web server should return"
  type        = string
  default     = "webserver production"
}
