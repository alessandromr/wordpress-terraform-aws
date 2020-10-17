resource "aws_ecs_service" "service" {
  name            = "${var.service_name}-${var.env}"
  task_definition = aws_ecs_task_definition.task_def.arn

  desired_count                      = var.service_desired_count
  cluster                            = var.ecs_cluster_arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = local.service_name
    container_port   = var.exposed_port
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  lifecycle {
    ignore_changes = [
      tags,
      desired_count
    ]
  }
}

data "template_file" "task_def_tpl" {
  template = file("${path.module}/task_definition_template.json")

  vars = {
    service_name                = local.service_name
    service_container_image_url = var.service_container_image_url
    service_cpu                 = var.service_cpu
    service_memory              = var.service_memory
    service_env_variables       = var.service_env_variables
    service_secrets             = var.service_secrets
    log_group                   = aws_cloudwatch_log_group.service_log.name
    aws_region                  = var.aws_region
    stream_prefix               = local.service_name
    exposed_port                = var.exposed_port
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                = "${var.prefix}-${var.env}-${local.service_name}-task-def"
  container_definitions = data.template_file.task_def_tpl.rendered
  task_role_arn         = aws_iam_role.task_role.arn
  network_mode          = "bridge"
  execution_role_arn    = aws_iam_role.task_execution_role.arn
}

resource "aws_cloudwatch_log_group" "service_log" {
  name              = "ecs/${var.prefix}/${var.env}/${local.service_name}"
  retention_in_days = var.retention_in_days
}
