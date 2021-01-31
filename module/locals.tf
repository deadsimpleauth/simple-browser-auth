
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


locals {
  container_definitions = templatefile("${path.module}/templates/container-definitions.tpl", {
    app_image      = var.app_image,
    app_port       = var.app_port,
    fargate_cpu    = var.fargate_cpu,
    fargate_memory = var.fargate_memory,
    aws_region     = data.aws_region.current.name,
    dsa_s3_bucket  = var.create_s3 == true ? aws_s3_bucket.dead_simple_auth_bucket[0].id : var.existing_s3_id,
    config_s3_path = var.config_s3_path,
    logs_s3_path   = var.log_s3_path
  })
}

