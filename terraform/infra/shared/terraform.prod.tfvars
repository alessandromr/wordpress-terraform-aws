project    = "example-site"
stack      = "shared-infra"
aws_region = "eu-west-1"
tags = {
  Project     = "example-site"
  Stack       = "shared-infra"
  Creator     = "AlessandroMarino"
  MaintenedBy = "Terraform_AlessandroMarino"
}

#dedicated
single_nat_gateway = false
enable_nat_gateway = true