variable "subdomain" {
  type        = string
  description = "The subdomain for this listener. Will also be the subdomain of the main domain used. e.g., if this is zombies.deadsimpleauth.com, enter 'zombies'"
}

variable "base_domain_name" {
  type        = string
  description = "The base domain name for the base alb."
}

variable "route53_zone_id" {
  type        = string
  description = "The route53 zone id for the zone hosting DNS for the base domain name."
}

variable "base_alb_dns_name" {
  type        = string
  description = "The base alb dns name"
}

variable "base_alb_arn" {
  type        = string
  description = "Arn of the base alb"
}

variable "base_alb_listener_arn" {
  type        = string
  description = "Arn of the listener to apply this redirection rule to"
}

variable "create_okta_app" {
  type        = bool
  default     = true
  description = "Whether to create a dedicated Okta app for this listener"
}

variable "assigned_okta_group_ids" {
  type        = list(string)
  default     = [""]
  description = "List of Okta group ids that should be authorized to sign in. This can be found as the random character string at the end of the URL when viewing the group in Okta "
}

variable "base_okta_url" {
  type        = string
  description = "Your base Okta URL"
}

variable "ecs_nginx_target_group_arn" {
  type        = string
  description = "The arn of the target group for the ECS nginx reverse proxy"
}

variable "origin_dns_domain" {
  type        = string
  description = "The DNS domain record of the origin (without https:// prefix) "
}

variable "dsa_s3_bucket_id" {
  type        = string
  description = "The S3 bucket id for hosting config and log files"
}

variable "config_s3_path" {
  description = "The path inside the S3 bucket to place nginx config files"
}

variable "log_s3_path" {
  description = "The path inside the S3 bucket to place log output"
}

/*
variable "assigned_okta_users" {
  type = list(string)
  default = [""]
  description = "List of Okta users that should be authorized to sign in."
}
*/
