resource "aws_elasticache_replication_group" "wordpress_session_storage" {
  automatic_failover_enabled = true

  replication_group_id          = "${local.prefix}-${terraform.workspace}-wp"
  replication_group_description = "Redis replicated cluster for wordpress"

  node_type             = var.redis_node_type
  number_cache_clusters = var.redis_node_count

  parameter_group_name = "default.redis6.x"
  engine               = "redis"
  engine_version       = "6.x"

  port = 6379

  subnet_group_name = aws_elasticache_subnet_group.wp_sess_storage_subnet_group.name

  lifecycle {
    ignore_changes = [
      engine_version,
    ]
  }
}


resource "aws_elasticache_subnet_group" "wp_sess_storage_subnet_group" {
  name       = "${local.prefix}-${terraform.workspace}-wordpress-session-storage-subnet-group"
  subnet_ids = local.database_subnets_ids
}
