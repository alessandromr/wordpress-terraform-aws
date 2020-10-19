resource "aws_iam_role" "task_role" {
  name               = "${var.prefix}-${var.short_service_name}-${var.env}-TaskRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.task_role_assume_policy_doc.json
}

data "aws_iam_policy_document" "task_role_assume_policy_doc" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "task_role_attachment" {
  policy_arn = aws_iam_policy.task_policy.arn
  role       = aws_iam_role.task_role.name
}

resource "aws_iam_role_policy" "input_policies_task_role_attachment" {
  count  = length(var.policies)
  policy = element(var.policies, count.index)
  role   = aws_iam_role.task_role.name
}

resource "aws_iam_policy" "task_policy" {
  name   = "${var.prefix}-${var.short_service_name}-${var.env}-TaskPolicy"
  policy = data.aws_iam_policy_document.task_policy_document.json
}

data "aws_iam_policy_document" "task_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
    ] #not needed?

    // TODO Reduce policy resource scope
    resources = ["*"]
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.prefix}-${var.short_service_name}-${var.env}-TaskExecutionRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.task_role_assume_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "task_execution_role_attachment" {
  policy_arn = aws_iam_policy.task_execution_policy.arn
  role       = aws_iam_role.task_execution_role.name
}

resource "aws_iam_policy" "task_execution_policy" {
  name   = "${var.prefix}-${var.short_service_name}-${var.env}-TaskExecutionPolicy"
  policy = data.aws_iam_policy_document.task_execution_policy.json
}

data "aws_iam_policy_document" "task_execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "task_execution_secrets_role_attachment" {
  count      = length(var.secrets_arns) > 0 ? 1 : 0
  policy_arn = aws_iam_policy.task_execution_secrets_policy[0].arn
  role       = aws_iam_role.task_execution_role.name
}

resource "aws_iam_policy" "task_execution_secrets_policy" {
  name   = "${var.prefix}-${var.short_service_name}-${var.env}-TaskExecutionSecretsPolicy"
  count  = length(var.secrets_arns) > 0 ? 1 : 0
  policy = data.aws_iam_policy_document.task_execution_secrets_policy.json
}

data "aws_iam_policy_document" "task_execution_secrets_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "ssm:GetParameters"
    ]
    resources = var.secrets_arns
  }
}