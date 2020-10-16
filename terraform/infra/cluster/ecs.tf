
data "aws_ecs_cluster" "ecs-wordpress" {
  cluster_name = "${local.prefix}-${terraform.workspace}-${var.cluster_name}"
}