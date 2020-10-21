resource "aws_elasticache_replication_group" "wordpress_session_storage" {
  automatic_failover_enabled = true

  replication_group_id          = "${local.prefix}-${terraform.workspace}-wp"
  replication_group_description = "Redis replicated cluster for wordpress"

  node_type = var.redis_node_type

  parameter_group_name = aws_elasticache_parameter_group.wp_sess_storage_parameter_group.name
  engine               = "redis"
  engine_version       = "6.x"

  port = 6379

  subnet_group_name  = aws_elasticache_subnet_group.wp_sess_storage_subnet_group.name

  cluster_mode {
    replicas_per_node_group = var.redis_replicas_per_node
    num_node_groups         = var.redis_node_number
  }
}

resource "aws_elasticache_subnet_group" "wp_sess_storage_subnet_group" {
  name       = "${local.prefix}-${terraform.workspace}-wordpress-session-storage-subnet-group"
  subnet_ids = local.database_subnets_ids
}

resource "aws_elasticache_parameter_group" "wp_sess_storage_parameter_group" {
  name   = "${local.prefix}-${terraform.workspace}-wp-parameter-group"
  family = "redis6.x"

  parameter {
    name  = "cluster-enabled"
    value = "yes"
  }
}