resource "aws_efs_file_system" "wordpress_file_system" {
  creation_token = "${local.prefix}-${terraform.workspace}-wordpress-file-system"

  tags = var.tags
}

resource "aws_efs_mount_target" "mount_target" {
  count = length(local.private_subnets_ids)
  file_system_id = aws_efs_file_system.wordpress_file_system.id
  subnet_id      = element(local.private_subnets_ids, count.index)
  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name        = "${local.prefix}-${terraform.workspace}-ecs-instances-security-group"
  description = "Allow TLS inbound traffic"
  vpc_id      = local.vpc_id
}

resource "aws_security_group_rule" "efs_allow_inbound_from_ecs" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.efs.id
  source_security_group_id = local.ecs_instances_sg_id
}

resource "aws_security_group_rule" "efs_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.efs.id
  source_security_group_id = local.ecs_instances_sg_id
}

resource "aws_security_group_rule" "ecs_allow_inbound_from_efs" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = local.ecs_instances_sg_id
  source_security_group_id = aws_security_group.efs.id
}