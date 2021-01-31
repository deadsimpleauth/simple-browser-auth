variable "create_vpc" {
  type        = bool
  default     = true
  description = "Whether or not to create a VPC for the base ALB. If set to false, vpc_arn and subnet_ids must be specified"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "If create_vpc is set to false, the vpc_id must be specified"
}

variable "public_subnets" {
  type        = list(any)
  default     = [""]
  description = "If create_vpc is set to false, the public subnets in the VPC for the ALB must be specified"
}

variable "private_subnets" {
  type        = list(any)
  default     = [""]
  description = "If create_vpc is set to false, the private subnets in the VPC for the ECS nginx reverse proxies must be specified"
}

variable "identity_provider" {
  type        = string
  default     = "okta"
  description = "Root of your identity provider. Currently only Okta authentication is supported."
}

variable "certificate_arn" {
  type        = string
  description = "The AWS certifcate ARN for HTTPS listeners. Should be a wildcard of base domain name."
}

variable "base_domain_name" {
  type        = string
  default     = "deadsimpleauth.com"
  description = "the root domain for the base alb with no protocol specified. e.g. 'example.com' "
}

variable "route53_zone_id" {
  type        = string
  description = "The route53 zone id for the zone hosting DNS for the base domain name."
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "deadsimpleauth/nginx:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 443
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "create_s3" {
  description = "Whether to create an S3 bucket for nginx configuration and logging. If false, you must specify an existing s3 bucket arn"
  default     = true
}

variable "existing_s3_id" {
  description = "If create_s3 is set to false, put in an existing s3 bucket id in here"
  default     = ""
}

variable "config_s3_path" {
  description = "The path inside the S3 bucket to place nginx config files"
  default     = "dead-simple-auth/config/"
}

variable "log_s3_path" {
  description = "The path inside the S3 bucket to place log output"
  default     = "dead-simple-auth/logs/"
}

variable "base_okta_url" {
  type        = string
  description = "Your base Okta URL"
}

variable "authed_listeners" {
  #TODO - add validation to the variable inputs
  description = "A lists of maps including all the necessary variables for each authenticated listener. Origins must support HTTPS. e.g. If assigned_okta_groups is null, it will default to the everyone group"
  type        = list(any)
  default = [
    {
      subdomain            = "http-cat"
      origin               = "http.cat"
      assigned_okta_groups = [""]
    },
    {
      subdomain            = "fast"
      origin               = "fast.com"
      assigned_okta_groups = [""]
    },
    {
      subdomain            = "blog"
      origin               = "blog.benjamin-hering.com"
      assigned_okta_groups = [""]
    }
  ]
}