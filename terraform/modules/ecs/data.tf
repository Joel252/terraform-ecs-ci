data "aws_iam_role" "execution" {
  count = var.execution_role_name != null ? 1 : 0

  name = var.execution_role_name
}

data "aws_iam_role" "task" {
  count = var.task_role_name != null ? 1 : 0

  name = var.task_role_name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
