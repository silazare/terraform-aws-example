// ASG module test example to deploy in default VPC
module "asg_example" {
  source = "../../modules/asg"

  cluster_name = var.cluster_name

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  min_size           = 1
  max_size           = 1
  enable_autoscaling = false
  enable_alb         = false
  alb_security_group = var.alb_security_group

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids
}
