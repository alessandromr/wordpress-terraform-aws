project="example-wordpress"
stack="data-persistence"
aws_region="eu-south-1"
tags = {
  Project     = "example-wordpress"
  Stack       = "data-persistence"
  Creator     = "AlessandroMarino"
  MaintenedBy = "Terraform_AlessandroMarino"
}

#dedicated variables

redis_node_type="cache.t3.micro"
redis_node_count=2

rds_instance_type="db.t3.small"
rds_connections_to_scale=120 #70% of "db.t3.small" max connections
rds_max_replicas=3
rds_min_replicas=1