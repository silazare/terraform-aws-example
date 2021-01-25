// Database remote backend, using to pass output vars to user-data.sh script
data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket         = var.db_remote_state_bucket
    key            = var.db_remote_state_key
    region         = var.db_remote_state_region
    dynamodb_table = var.db_dynamodb_table
    encrypt        = true
  }
}

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
    values = ["*public*"]
  }
}

// EC2 part
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
