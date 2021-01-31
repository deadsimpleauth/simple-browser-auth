module "authed_listener" {
  count = length(var.authed_listeners)

  source                     = "./authed-listener"
  assigned_okta_group_ids    = var.authed_listeners[count.index]["assigned_okta_groups"]
  base_alb_arn               = aws_lb.dead_simple_auth_alb.arn
  base_alb_dns_name          = aws_lb.dead_simple_auth_alb.dns_name
  base_alb_listener_arn      = aws_lb_listener.https_default.arn
  base_domain_name           = var.base_domain_name
  base_okta_url              = var.base_okta_url
  config_s3_path             = var.config_s3_path
  dsa_s3_bucket_id           = var.create_s3 == true ? aws_s3_bucket.dead_simple_auth_bucket[0].id : var.existing_s3_id
  ecs_nginx_target_group_arn = aws_lb_target_group.nginx_reverse_proxy.arn
  log_s3_path                = var.log_s3_path
  origin_dns_domain          = var.authed_listeners[count.index]["origin"]
  route53_zone_id            = var.route53_zone_id
  subdomain                  = var.authed_listeners[count.index]["subdomain"]

}