locals {
  vpc_id = data.terraform_remote_state.shared_infra.outputs.vpc_id

  ecs_cluster_id = data.terraform_remote_state.cluster.outputs.ecs_cluster_id
  ecs_cluster_arn  = data.terraform_remote_state.cluster.outputs.ecs_cluster_arn

  wordpress_image_url  = data.terraform_remote_state.shared_infra.outputs.wordpress_image_url
  nginx_image_url  = data.terraform_remote_state.shared_infra.outputs.nginx_image_url

  wordpress_file_system_arn  = data.terraform_remote_state.data.outputs.wordpress_file_system_arn
  wordpress_file_system_id  = data.terraform_remote_state.data.outputs.wordpress_file_system_id

  wordpress_db_endpoint  = data.terraform_remote_state.data.outputs.wordpress_db_endpoint
  wordpress_db_sg_id  = data.terraform_remote_state.data.outputs.wordpress_db_sg_id
  wordpress_db_port  = data.terraform_remote_state.data.outputs.wordpress_db_port
  wordpress_db_user  = data.terraform_remote_state.data.outputs.wordpress_db_user
  wordpress_db_password_ssm_arn  = data.terraform_remote_state.data.outputs.wordpress_db_password_ssm_arn

  wordpress_session_storage_cluster_endpoint  = data.terraform_remote_state.data.outputs.wordpress_db_password_ssm_arn
  wordpress_session_storage_config_endpoint  = data.terraform_remote_state.data.outputs.wordpress_session_storage_config_endpoint

  aws_lb_listener_arn = data.terraform_remote_state.cluster.outputs.aws_lb_listener_arn
}

data "terraform_remote_state" "shared_infra" {
  backend = "s3"
  config = {
    bucket = "scalable-wp-onaws"
    key    = "example-site/${terraform.workspace}/shared-infra"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = "scalable-wp-onaws"
    key    = "example-site/${terraform.workspace}/cluster"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "data" {
  backend = "s3"
  config = {
    bucket = "scalable-wp-onaws"
    key    = "example-site/${terraform.workspace}/data"
    region = "eu-west-1"
  }
}