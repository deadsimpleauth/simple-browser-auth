/*
# Okta oath app
resource "okta_app_oauth" "this" {
  label          = local.hostname
  type           = "web"
  response_types = ["code"]
  grant_types    = ["authorization_code"]
  redirect_uris = [join("", ["https://",local.hostname,"/oath2/idpresponse"])]
  hide_web = true
  hide_ios = true

  lifecycle {
    ignore_changes = [users, groups]
  }
}
*/

# Okta SAML App
resource "okta_app_saml" "this" {
  label                    = local.hostname
  hide_ios                 = true
  hide_web                 = true
  sso_url                  = join("", [local.full_cognito_domain, "/saml2/idpresponse"])
  recipient                = join("", [local.full_cognito_domain, "/saml2/idpresponse"])
  destination              = join("", [local.full_cognito_domain, "/saml2/idpresponse"])
  audience                 = join("", ["urn:amazon:cognito:sp:", aws_cognito_user_pool.this_pool.id])
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  subject_name_id_template = "$${user.userName}"
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  honor_force_authn        = false
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  assertion_signed         = true

  lifecycle {
    ignore_changes = [users, groups]
  }

}

resource "okta_app_group_assignment" "this" {
  count    = length(local.assigned_okta_group_ids)
  app_id   = okta_app_saml.this.id
  group_id = local.assigned_okta_group_ids[count.index]
}


/*
TODO - allow assigning individuals as well as groups
resource "okta_app_user" "this" {
  count = length(var.assigned_okta_users)
  app_id = okta_app_oauth.this.id
  user_id = ""
  username = ""
}
*/