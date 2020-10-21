project    = "example-site"
stack      = "cluster"
aws_region = "eu-west-1"
tags = {
  Project     = "example-site"
  Stack       = "cluster"
  Creator     = "AlessandroMarino"
  MaintenedBy = "Terraform_AlessandroMarino"
}

#dedicated variables

cluster_name = "wordpress"

cluster_min_size         = 3
cluster_max_size         = 6
cluster_desired_capacity = 3

instance_type = "t3.small"

#capacity_provider
maximum_scaling_step_size             = 2
minimum_scaling_step_size             = 1
capacity_provider_desired_utilization = 90