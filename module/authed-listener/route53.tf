resource "aws_route53_record" "base" {
  zone_id = var.route53_zone_id
  name    = local.hostname
  type    = "CNAME"
  ttl     = "60"
  records = [var.base_alb_dns_name]
}