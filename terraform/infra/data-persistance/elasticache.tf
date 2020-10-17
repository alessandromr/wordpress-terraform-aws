resource "aws_elasticache_cluster" "wordpress_session_storage" {
  cluster_id           = "${local.prefix}-${terraform.workspace}-wordpress-session-storage"
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_node_count
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
}