resource "aws_ecs_cluster" "ecs_wordpress" {
  name               = "${local.prefix}-${terraform.workspace}-${var.cluster_name}"
  capacity_providers = [aws_ecs_capacity_provider.ecs_wordpress.name]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_ecs_capacity_provider" "ecs_wordpress" {
  name = "${local.prefix}-${terraform.workspace}-${var.cluster_name}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_instances.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = var.minimum_scaling_step_size
      minimum_scaling_step_size = var.minimum_scaling_step_size
      status                    = "ENABLED"
      target_capacity           = var.capacity_provider_desired_utilization
    }
  }
}
