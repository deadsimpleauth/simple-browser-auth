data "aws_region" "current" {}

data "aws_iam_policy_document" "dsa_ecs_execution_policy" {
  # Basic permissions for ECS tasks and allow target registration to load balancers
  statement {
    sid = "ECSTaskRights"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]

    effect = "Allow"
    #TODO Tighten this down to specific resources
    resources = [
      "*",
    ]
  }

}

data "aws_iam_policy_document" "assume_from_ecs" {
  statement {

    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com", "ecs.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "dsa_ecs_task_policy" {
  # Allow the container to push logs and pull config
  statement {
    sid = "ListBucket"

    actions = ["s3:ListBucket"]

    effect = "Allow"

    resources = ["arn:aws:s3:::${var.create_s3 == true ? aws_s3_bucket.dead_simple_auth_bucket[0].id : var.existing_s3_id}"]
  }

  statement {
    sid = "PullConfigFromS3"

    actions = ["s3:GetObject", "s3:ListObjects"]

    effect = "Allow"

    resources = ["arn:aws:s3:::${var.create_s3 == true ? aws_s3_bucket.dead_simple_auth_bucket[0].id : var.existing_s3_id}/${var.config_s3_path}*"]
  }

  statement {
    sid = "PushLogstoS3"

    actions = ["s3:PutObject"]

    effect = "Allow"

    resources = ["arn:aws:s3:::${var.create_s3 == true ? aws_s3_bucket.dead_simple_auth_bucket[0].id : var.existing_s3_id}/${var.log_s3_path}*"]
  }

}
/*
data "template_file" "container_definitions" {
  templates = file("${module_path}/templates/container-definitions.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = data.aws_region.current
  }
}
*/
