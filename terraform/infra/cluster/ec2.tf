resource "aws_autoscaling_group" "ecs_instances" {
  name                = "${local.prefix}-${terraform.workspace}-asg"
  vpc_zone_identifier = local.private_subnets_ids

  min_size = var.cluster_min_size
  max_size = var.cluster_max_size

  protect_from_scale_in = true

  launch_template {
    id      = aws_launch_template.launch_templates.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }

  tag {
    key                 = "Name"
    value               = "${local.prefix}-${terraform.workspace}-asg"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_launch_template" "launch_templates" {
  image_id  = data.aws_ami.amazon_linux_2.image_id
  user_data = base64encode(data.template_file.user_data.rendered)

  instance_type = var.instance_type

  # SSH keys not used, use SSM to log in
  # key_name  = var.cluster_instances_key_name

  network_interfaces {
    security_groups             = [aws_security_group.ecs_instances.id]
    associate_public_ip_address = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instances.name
  }
  tags = merge(var.tags,
    {
      Name             = "${local.prefix}-${terraform.workspace}-launch-config",
      AmazonECSManaged = true
    }
  )
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    ClusterName = "${local.prefix}-${terraform.workspace}-${var.cluster_name}"
  }
}


data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_security_group" "ecs_instances" {
  name        = "${local.prefix}-${terraform.workspace}-ecs-instances-security-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id
}

resource "aws_security_group_rule" "ecs_allow_inbound_from_alb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ecs_instances.id
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ecs_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_instances.id
}
