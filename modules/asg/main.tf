resource "aws_security_group" "this" {
  name   = "${var.cluster_name}-instance"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_server_http_inbound_alb" {
  count = var.enable_alb ? 1 : 0

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  from_port                = var.server_port
  to_port                  = var.server_port
  protocol                 = local.tcp_protocol
  source_security_group_id = var.alb_security_group
}

resource "aws_security_group_rule" "allow_server_http_inbound_simple" {
  count = var.enable_alb ? 0 : 1

  type              = "ingress"
  security_group_id = aws_security_group.this.id

  from_port   = local.port
  to_port     = local.port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_launch_configuration" "this" {
  // For zero-downtime deployment
  // Use name_prefix in launch configuration (so a random name could be generated)
  name_prefix     = "${var.cluster_name}-"
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.this.id]
  user_data       = var.user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  // For zero-downtime deployment
  // Explicitly depend on the launch configuration's name so each time it's replaced, this ASG is also will be replaced
  name = aws_launch_configuration.this.name

  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = var.target_group_arns
  health_check_type    = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  // For zero-downtime deployment
  // Wait for at least this many instances to pass health checks before considering the ASG deployment complete
  min_elb_capacity = var.min_size

  // For zero-downtime deployment
  // When replacing this ASG, create the replacement first, and only delete the original after
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags :
      key => value
      if key != "Name"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 10
  recurrence             = "0 9 * * *"
  autoscaling_group_name = aws_autoscaling_group.this.name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name  = "${var.cluster_name}-scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * *"
  autoscaling_group_name = aws_autoscaling_group.this.name
}

// CloudWatch part
// Alarm that goes off if the average CPU utilization in the cluster is more than 90% during a 5-minute period
resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 90
  unit                = "Percent"
}

// Alarm that goes off when CPU credits are low for t.xxx instances only
resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}
