resource "aws_elasticache_cluster" "wordpress_session_storage" {
  cluster_id           = "${local.prefix}-${terraform.workspace}-wordpress-session-storage"
  
  parameter_group_name = "default.redis3.2"

  engine               = "redis"
  engine_version       = "3.2.10"
  port                 = 6379

  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_node_count

  subnet_group_name = aws_elasticache_subnet_group.wp_sess_storage_subnet_group
}


resource "aws_elasticache_subnet_group" "wp_sess_storage_subnet_group" {
  name       = "${local.prefix}-${terraform.workspace}-wordpress-session-storage-subnet-group"
  subnet_ids = local.private_subnets_ids
}