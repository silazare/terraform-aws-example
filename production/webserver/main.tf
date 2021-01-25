module "webserver_cluster" {
  source = "../../modules/webserver"

  cluster_name = var.cluster_name
  environment  = var.environment
  server_text  = var.server_text

  ami                = data.aws_ami.ubuntu.id
  instance_type      = "t3.micro"
  min_size           = 1
  max_size           = 10
  enable_autoscaling = true

  db_address = data.terraform_remote_state.db.outputs.address
  db_port    = data.terraform_remote_state.db.outputs.port

  vpc_id     = data.aws_vpc.custom.id
  subnet_ids = data.aws_subnet_ids.custom.ids

  custom_tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}
