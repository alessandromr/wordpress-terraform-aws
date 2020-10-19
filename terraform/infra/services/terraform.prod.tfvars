project="example-site"
stack="services"
aws_region="eu-west-1"
tags = {
  Project     = "example-site"
  Stack       = "services"
  Creator     = "AlessandroMarino"
  MaintenedBy = "Terraform_AlessandroMarino"
}

#dedicated variables

services_params = {
  "wordpress-service" = {
    min_count          = 3
    max_count          = 6
    desidered_count    = 3
    service_memory     = 448
    service_cpu        = 512
    env_vars = {}
  },