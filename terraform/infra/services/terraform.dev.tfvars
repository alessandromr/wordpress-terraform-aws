project    = "example-site"
stack      = "services"
aws_region = "eu-west-1"
tags = {
  Project     = "example-site"
  Stack       = "services"
  Creator     = "AlessandroMarino"
  MaintenedBy = "Terraform_AlessandroMarino"
}

#dedicated variables

wordpress_desired_count = 3

services_params = {
  "php" = {
    service_memory = 128
    service_cpu    = 128
    env_vars       = {}
  },
  "nginx" = {
    service_memory = 128
    service_cpu    = 128
    env_vars       = {}
  }
}
log_retention_in_days = 7