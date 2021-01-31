locals {
  hostname            = join(".", [var.subdomain, var.base_domain_name])
  full_cognito_domain = join("", ["https://", aws_cognito_user_pool_domain.this_domain.domain, ".auth.", data.aws_region.current.name, ".amazoncognito.com"])

  assigned_okta_group_ids = length(var.assigned_okta_group_ids) == 0 ? [data.okta_everyone_group.everyone_group.id] : var.assigned_okta_group_ids
  nginx_reverse_proxy_config = templatefile("${path.module}/templates/nginx-proxy-conf.tpl", {
    origin_dns_domain = var.origin_dns_domain,
    nginx_server_name = local.hostname
  })
}