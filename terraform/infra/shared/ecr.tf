resource "aws_ecr_repository" "wordpress_image" {
  name                 = "${local.prefix}-${terraform.workspace}-wordpress"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "nginx_image" {
  name                 = "${local.prefix}-${terraform.workspace}-nginx"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "wordpress_image_policy" {
  repository = aws_ecr_repository.wordpress_image.name

  policy = data.aws_iam_policy_document.ecr_policy_document.json
}

resource "aws_ecr_repository_policy" "nginx_image_policy" {
  repository = aws_ecr_repository.nginx_image.name

  policy = data.aws_iam_policy_document.ecr_policy_document.json
}

data "aws_iam_policy_document" "ecr_policy_document" {
  version = "2008-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
    ]
    principals {
      identifiers = [data.aws_caller_identity.current.account_id]
      type        = "AWS"
    }
  }
}