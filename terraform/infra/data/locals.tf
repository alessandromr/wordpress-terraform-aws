data "aws_caller_identity" "current" {}

locals {
  prefix = "${var.project}-${var.stack}"
}