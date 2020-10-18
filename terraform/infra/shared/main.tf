terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  
  backend "s3" {
    bucket = "scalable-wp-onaws"
    workspace_key_prefix = "example-site"
    key    = "shared-infra"
    region = "eu-west-1"
    dynamodb_table="scalable-wp-onaws"
  }
}

provider "aws" {
  region = var.aws_region
}

