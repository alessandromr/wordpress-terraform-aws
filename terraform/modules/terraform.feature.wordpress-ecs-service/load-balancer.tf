resource "aws_alb_target_group" "service_target_group" {
  name                 = "${var.service_name}-${var.env}"
  protocol             = "HTTP"
  port                 = var.exposed_port
  vpc_id               = var.vpc_id
  deregistration_delay = 30
  target_type = "ip"

  health_check {
    path     = var.service_health_check_path
    matcher  = var.service_health_check_matcher
    timeout  = var.service_health_check_timeout
    interval = var.service_health_check_interval
  }
}


resource "aws_alb_listener_rule" "service_listener" {
  count        = length(var.alb_rule_priority)
  listener_arn = var.load_balancer_listener_arn
  priority     = element(var.alb_rule_priority, count.index)
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }
  condition {
    path_pattern {
      values = [element(var.alb_path_patterns, count.index)]
    }
  }
}