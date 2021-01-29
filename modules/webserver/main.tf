module "asg" {
  source = "../asg"

  cluster_name  = "${var.cluster_name}-${var.environment}"
  ami           = var.ami
  user_data     = local.user_data
  instance_type = var.instance_type

  min_size           = var.min_size
  max_size           = var.max_size
  enable_autoscaling = var.enable_autoscaling
  enable_alb         = true

  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  alb_security_group = module.alb.alb_security_group_id
  target_group_arns  = [aws_lb_target_group.asg.arn]
  health_check_type  = "ELB"

  custom_tags = var.custom_tags
}

module "alb" {
  source = "../alb"

  alb_name   = "${var.cluster_name}-${var.environment}-lb"
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
}

resource "aws_lb_target_group" "asg" {
  name     = "${var.cluster_name}-${var.environment}"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}
