module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "production-vpc"
  cidr = "10.100.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.100.10.0/24", "10.100.11.0/24", "10.100.12.0/24"]
  public_subnets  = ["10.100.20.0/24", "10.100.21.0/24", "10.100.22.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "production"
  }
}

