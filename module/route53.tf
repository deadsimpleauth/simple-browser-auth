resource "aws_route53_record" "base" {
  zone_id = var.route53_zone_id
  name    = "base"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.dead_simple_auth_alb.dns_name]
}