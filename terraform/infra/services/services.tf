module "wordpress_service" {
  source = "../../modules/terraform.feature.wordpress-ecs-service"

  aws_region = var.aws_region
  account_id = data.aws_caller_identity.current.account_id
  prefix     = local.prefix
  env        = terraform.workspace

  service_name       = "service-wordpress"
  short_service_name = "wp"

  vpc_id          = local.vpc_id
  ecs_cluster_arn = local.ecs_cluster_arn

  exposed_port               = 80
  alb_path_patterns          = ["/*"]
  alb_rule_priority          = [100]
  load_balancer_listener_arn = local.aws_lb_listener_arn

  service_health_check_path     = "/"
  service_health_check_timeout  = 30
  service_health_check_interval = 60

  service_desired_count = var.wordpress_desired_count

  efs_id         = local.wordpress_file_system_id

  php = {
    "image_url" = "${local.wordpress_image_url}:LATEST"
    "cpu"       = var.services_params["php"].service_cpu
    "memory"    = var.services_params["php"].service_memory
    "secrets"   = <<EOF
{"name":"WORDPRESS_DB_PASSWORD","valueFrom":"${local.wordpress_db_password_ssm_arn}"}
EOF
    "envs"      = <<EOF
{"name":"AWS_REGION","value":"${var.aws_region}"},
{"name":"WORDPRESS_DB_HOST","value":"${local.wordpress_db_endpoint}"},
{"name":"WORDPRESS_DB_USER","value":"${local.wordpress_db_user}"},
{"name":"redis_php_ini_save_path","value":"${local.wordpress_session_storage_cluster_endpoint}"}
EOF
  }

  nginx = {
    "image_url" = "${local.nginx_image_url}:LATEST"
    "cpu"       = var.services_params["nginx"].service_cpu
    "memory"    = var.services_params["nginx"].service_memory
    "secrets"   = ""
    "envs"      = <<EOF
{"name":"AWS_REGION","value":"${var.aws_region}"}
EOF
  }

  secrets_arns = [local.wordpress_db_password_ssm_arn]

  policies = [
    //rds policy
    //elasticache policy
    //efs policy
  ]

  retention_in_days = var.log_retention_in_days
}
