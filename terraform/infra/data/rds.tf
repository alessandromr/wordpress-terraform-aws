module "wordpress_db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  name = "${local.prefix}-${terraform.workspace}-wp-db"

  engine         = "aurora-mysql"
  engine_version = "5.7"
  port           = 3306

  vpc_id               = local.vpc_id
  db_subnet_group_name = local.database_subnets_group

  instance_type       = var.rds_instance_type
  storage_encrypted   = true
  monitoring_interval = 10

  db_parameter_group_name         = "default.aurora-mysql5.7"
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  password = random_password.db_password.result
  username = random_string.db_username.result

  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "sun:03:30-sun:05:00"
  apply_immediately            = false

  replica_scale_connections = var.rds_connections_to_scale
  replica_scale_cpu         = 75
  replica_scale_enabled     = true

  replica_scale_max = var.rds_max_replicas
  replica_scale_min = var.rds_min_replicas

  tags = var.tags
}

resource "random_string" "db_username" {
  length  = 15
  upper   = false
  number  = false
  special = false
}

resource "random_password" "db_password" {
  length           = 20
  upper            = true
  number           = true
  special          = true
  override_special = "-_.$"
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${local.prefix}/${var.environment}/database/rds/password"
  description = "SSM Parameter for wordpress database"
  type        = "SecureString"
  value       = "${random_password.db_password.result}"

  tags = var.tags
}