// Webserver module test example to deploy in default VPC
module "webserver" {
  source = "../../modules/webserver"

  cluster_name = var.cluster_name
  environment  = var.environment

  db_address  = var.db_address
  db_port     = var.db_port
  server_text = var.server_text

  ami                = data.aws_ami.ubuntu.id
  instance_type      = "t3.micro"
  min_size           = 1
  max_size           = 1
  enable_autoscaling = false

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids
}
