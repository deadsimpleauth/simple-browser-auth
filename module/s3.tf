resource "random_pet" "s3" {
  length = 2
}

resource "aws_s3_bucket" "dead_simple_auth_bucket" {
  count  = var.create_s3 == true ? 1 : 0
  bucket = "dead-simple-auth-${random_pet.s3.id}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "config_readme" {
  bucket = var.create_s3 == true ? aws_s3_bucket.dead_simple_auth_bucket[0].id : var.existing_s3_id
  key    = "${var.config_s3_path}/config-readme.txt"
  source = "${path.module}/files/config-readme.txt"

  etag = filemd5("${path.module}/files/config-readme.txt")
}
