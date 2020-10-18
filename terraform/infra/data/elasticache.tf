resource "aws_elasticache_replication_group" "wordpress_session_storage" {
  automatic_failover_enabled = true

  replication_group_id          = "${local.prefix}-${terraform.workspace}-wp"
  replication_group_description = "Redis replicated cluster for wordpress"

  node_type             = var.redis_node_type
  number_cache_clusters = var.redis_node_count

  parameter_group_name = "default.redis3.2"
  engine               = "redis"
  engine_version       = "3.2.10"

  port = 6379

  availability_zones = local.azs
  subnet_group_name  = aws_elasticache_subnet_group.wp_sess_storage_subnet_group.name
}


resource "aws_elasticache_subnet_group" "wp_sess_storage_subnet_group" {
  name       = "${local.prefix}-${terraform.workspace}-wordpress-session-storage-subnet-group"
  subnet_ids = local.database_subnets_ids
}
