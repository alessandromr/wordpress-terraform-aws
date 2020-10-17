resource "aws_iam_role" "ecs_instances" {
  name               = "${var.stack}-${terraform.workspace}-ecs-instance-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        "ec2.amazonaws.com"
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_instance_profile" "ecs_instances" {
  name = "${var.stack}-${terraform.workspace}-ecs-instance-profile"
  role = aws_iam_role.ecs_instances.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = aws_iam_role.ecs_instances.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = aws_iam_role.ecs_instances.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}