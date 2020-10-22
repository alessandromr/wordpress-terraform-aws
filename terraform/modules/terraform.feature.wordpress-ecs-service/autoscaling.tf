
module "scale_up" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 1.0"

  alarm_name          = "${var.prefix}-${var.service_name}-${var.env}-ecs-alarm-scale-up"
  alarm_description   = "CPU Metrics on ecs service ${var.service_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 1
  threshold          = 75
  period             = 60

  namespace   = "AWS/ECS"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [aws_appautoscaling_policy.ecs_scale_up.arn]

}

module "scale_down" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 1.0"

  alarm_name          = "${var.prefix}-${var.service_name}-${var.env}-ecs-alarm-scale-down"
  alarm_description   = "CPU Metrics on ecs service ${var.service_name}"
  comparison_operator = "LessThanOrEqualToThreshold"

  evaluation_periods = 2
  threshold          = 40
  period             = 60

  namespace   = "AWS/ECS"
  metric_name = "CPUUtilization"
  statistic   = "Average"

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.service.name
  }
  
  alarm_actions = [aws_appautoscaling_policy.ecs_scale_down.arn]
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.service_max_count
  min_capacity       = var.service_min_count
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_scale_up" {
  name               = "${var.prefix}-${var.service_name}-${var.env}-ecs-scale_up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 10
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_scale_down" {
  name               = "${var.prefix}-${var.service_name}-${var.env}-ecs-scale_down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}
