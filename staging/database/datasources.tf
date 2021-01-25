// VPC remote backend
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket         = var.vpc_remote_state_bucket
    key            = var.vpc_remote_state_key
    region         = var.vpc_remote_state_region
    dynamodb_table = var.vpc_dynamodb_table
    encrypt        = true
  }
}

// Custom VPC from remote backend
data "aws_vpc" "custom" {
  id = data.terraform_remote_state.vpc.outputs.vpc_id
}

data "aws_subnet_ids" "custom" {
  vpc_id = data.aws_vpc.custom.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}
