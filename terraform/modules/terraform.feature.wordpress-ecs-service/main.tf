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
    container_name   = "${var.service_name}-nginx"
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
    service_name = var.service_name

    service_container_image_url_php = var.php["image_url"]
    service_cpu_php                 = var.php["cpu"]
    service_memory_php              = var.php["memory"]
    service_env_variables_php       = var.php["envs"]
    service_secrets_php             = var.php["secrets"]

    service_container_image_url_nginx = var.nginx["image_url"]
    service_cpu_nginx                 = var.nginx["cpu"]
    service_memory_nginx              = var.nginx["memory"]
    service_env_variables_nginx       = var.nginx["envs"]
    service_secrets_nginx             = var.nginx["secrets"]

    exposed_port = var.exposed_port

    aws_region    = var.aws_region
    log_group     = aws_cloudwatch_log_group.service_log.name
    stream_prefix = var.service_name
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                = "${var.prefix}-${var.env}-${var.service_name}-task-def"
  container_definitions = data.template_file.task_def_tpl.rendered
  task_role_arn         = aws_iam_role.task_role.arn
  network_mode          = "bridge"
  execution_role_arn    = aws_iam_role.task_execution_role.arn

  volume {
    name = "main_storage"

    efs_volume_configuration {
      file_system_id          = var.efs_id
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
    }
  }
}

resource "aws_cloudwatch_log_group" "service_log" {
  name              = "ecs/${var.prefix}/${var.env}/${var.service_name}"
  retention_in_days = var.retention_in_days
}
