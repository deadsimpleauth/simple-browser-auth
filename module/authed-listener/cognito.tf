resource "aws_iam_saml_provider" "this" {
  name                   = join("-", [local.hostname, "saml-provider"])
  saml_metadata_document = okta_app_saml.this.metadata
}

resource "aws_cognito_user_pool" "this_pool" {
  name = join("-", [var.subdomain, "user-pool"])
}

resource "aws_cognito_user_pool_client" "this_client" {
  name                                 = join("-", [var.subdomain, "user-pool-client"])
  user_pool_id                         = aws_cognito_user_pool.this_pool.id
  generate_secret                      = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["openid", "profile"]
  callback_urls                        = [join("", ["https://", local.hostname, "/oauth2/idpresponse"])]
  supported_identity_providers         = [aws_cognito_identity_provider.this_saml_idp.provider_name]
}

resource "aws_cognito_user_pool_domain" "this_domain" {
  domain       = join("-", [var.subdomain, "dead-simple-auth-domain"])
  user_pool_id = aws_cognito_user_pool.this_pool.id
}

resource "aws_cognito_identity_provider" "this_saml_idp" {
  user_pool_id  = aws_cognito_user_pool.this_pool.id
  provider_name = "Okta"
  provider_type = "SAML"
  provider_details = {
    MetadataFile = okta_app_saml.this.metadata
  }
}