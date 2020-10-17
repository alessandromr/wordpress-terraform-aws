resource "aws_efs_file_system" "wordpress_file_system" {
  creation_token = "${local.prefix}-${terraform.workspace}-wordpress-file-system"

  tags = var.tags
}
