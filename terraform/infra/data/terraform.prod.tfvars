project    = "example-site"
stack      = "data"
aws_region = "eu-west-1"
tags = {
  Project     = "example-site"
  Stack       = "data"
  Creator     = "AlessandroMarino"
  MaintenedBy = "Terraform_AlessandroMarino"
}

#dedicated variables

redis_node_type  = "cache.t3.small"
redis_node_count = 2

rds_instance_type        = "db.t3.small"
rds_connections_to_scale = 120 #70% of "db.t3.small" max connections
rds_max_replicas         = 3
rds_min_replicas         = 2