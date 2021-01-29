// ALB module test example to deploy in default VPC
module "alb_example" {
  source = "../../modules/alb"

  alb_name   = var.alb_name
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids
}
