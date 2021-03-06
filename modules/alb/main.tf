resource "aws_lb" "this" {
  name               = var.alb_name
  load_balancer_type = "application"
  internal           = false #tfsec:ignore:AWS005 // this is test module
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = local.http_port
  protocol          = "HTTP" #tfsec:ignore:AWS004 // this is test module

  // By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name        = var.alb_name
  description = "${var.alb_name} security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_http_inbound" {
  description       = "${var.alb_name} HTTP traffic ingress"
  type              = "ingress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips #tfsec:ignore:AWS006 // this is test module
}

resource "aws_security_group_rule" "allow_all_outbound" {
  description       = "${var.alb_name} all traffic egress"
  type              = "egress"
  security_group_id = aws_security_group.alb.id

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips #tfsec:ignore:AWS007 // this is test module
}
