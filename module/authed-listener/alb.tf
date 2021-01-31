resource "aws_lb_listener_rule" "this" {
  listener_arn = var.base_alb_listener_arn

  action {
    type = "authenticate-cognito"

    authenticate_cognito {
      user_pool_arn              = aws_cognito_user_pool.this_pool.arn
      user_pool_client_id        = aws_cognito_user_pool_client.this_client.id
      user_pool_domain           = aws_cognito_user_pool_domain.this_domain.domain
      on_unauthenticated_request = "authenticate"
    }
  }

  action {
    type             = "forward"
    target_group_arn = var.ecs_nginx_target_group_arn
  }
  condition {
    host_header {
      values = [local.hostname]
    }
  }
}
/*
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }*/

/*
# OIDC Auth
 action {
    type = "authenticate-oidc"

    authenticate_oidc {
      client_id = okta_app_oauth.this.client_id
      client_secret = okta_app_oauth.this.client_secret
      authorization_endpoint = join("",[var.base_okta_url,"/oauth2/default/v1/authorize"])
      issuer = join("",[var.base_okta_url,"/oauth2/default/"])
      token_endpoint = join("",[var.base_okta_url,"/oauth2/default/v1/token"])
      user_info_endpoint = join("",[var.base_okta_url,"/oauth2/default/v1/token/userinfo"])
      session_cookie_name        = "AWSELBAuthSessionCookie"
      session_timeout            = "300"
      scope                      = "openid profile"
      on_unauthenticated_request = "authenticate"
    }
  }*/
