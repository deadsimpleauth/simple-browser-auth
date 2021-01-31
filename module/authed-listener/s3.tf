resource "aws_s3_bucket_object" "nginx_config" {
  bucket = var.dsa_s3_bucket_id
  key    = "${var.config_s3_path}/${local.hostname}.conf"
  source = "${path.module}/local-temp/${local.hostname}.conf"

  depends_on = [local_file.nginx_config]
}

#TODO there's got to be a way to upload this directly without writing to local disk

resource "local_file" "nginx_config" {
  filename = "${path.module}/local-temp/${local.hostname}.conf"
  content  = local.nginx_reverse_proxy_config
}