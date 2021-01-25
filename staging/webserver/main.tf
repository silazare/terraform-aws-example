module "webserver_cluster" {
  source = "../../modules/webserver"

  cluster_name = var.cluster_name
  environment  = var.environment
  server_text  = var.server_text

  ami                = data.aws_ami.ubuntu.id
  instance_type      = "t3.micro"
  min_size           = 1
  max_size           = 1
  enable_autoscaling = false

  db_address = data.terraform_remote_state.db.outputs.address
  db_port    = data.terraform_remote_state.db.outputs.port

  vpc_id     = data.aws_vpc.custom.id
  subnet_ids = data.aws_subnet_ids.custom.ids

  custom_tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "allow_testing_http_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.instance_security_group_id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_testing_ssh_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.instance_security_group_id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
