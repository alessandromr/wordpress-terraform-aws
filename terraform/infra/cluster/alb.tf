resource "aws_lb" "load_balancer" {
  name               = "${local.prefix}-${terraform.workspace}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]

  tags = var.tags
}

resource "aws_lb_listener" "default_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Error"
      status_code  = "500"
    }
  }
}

resource "aws_security_group" "alb" {
  name        = "${local.prefix}-${terraform.workspace}-ecs-instances-security-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id
}

resource "aws_security_group_rule" "alb_allow_inbound_http_from_internet" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}
resource "aws_security_group_rule" "alb_allow_inbound_https_from_internet" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_out" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks              = ["0.0.0.0/0"]
  source_security_group_id = aws_security_group.ecs_instances.id
  security_group_id        = aws_security_group.alb.id
}
