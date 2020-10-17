#efs
output "wordpress_file_system_arn" {
  value = aws_efs_file_system.wordpress_file_system.arn
}
output "wordpress_file_system_id" {
  value = aws_efs_file_system.wordpress_file_system.id
}
output "wordpress_file_system_dns" {
  value = aws_efs_file_system.wordpress_file_system.dns
}
#rds

output "wordpress_db_endpoint" {
  value = module.wordpress_db.this_rds_cluster_endpoint
}

output "wordpress_db_sg_id" {
  value = module.wordpress_db.this_security_group_id
}

output "wordpress_db_port" {
  value = module.wordpress_db.this_rds_cluster_port
}

#elasticache
output "wordpress_session_storage_cluster_address" {
  value =  aws_elasticache_cluster.wordpress_session_storage.cluster_address
}