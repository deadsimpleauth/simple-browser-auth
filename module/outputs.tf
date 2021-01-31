output "alb_arn" {
  value = aws_lb.dead_simple_auth_alb.arn
}

output "alb_dns_name" {
  value = aws_lb.dead_simple_auth_alb.dns_name
}

output "base_domain_name" {
  value = var.base_domain_name
}

output "https_listener_arn" {
  value = aws_lb_listener.https_default.arn
}

output "ecs_nginx_target_group_arn" {
  value = aws_lb_target_group.nginx_reverse_proxy.arn
}

output "dsa_s3_bucket_id" {
  value = var.create_s3 == true ? aws_s3_bucket.dead_simple_auth_bucket[0].id : var.existing_s3_id
}

output "config_s3_path" {
  value = var.config_s3_path
}

output "log_s3_path" {
  value = var.log_s3_path
}