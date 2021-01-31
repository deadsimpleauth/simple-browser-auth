resource "aws_lb" "dead_simple_auth_alb" {
  name               = "dead-simple-auth"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.dead_simple_auth_alb_sg.id]
  subnets            = var.create_vpc == true ? module.dead-simple-auth-vpc[0].public_subnets : var.public_subnets

  enable_deletion_protection = false
  /*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "alb-multipass"
    enabled = true
  }
  */
  tags = {
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.dead_simple_auth_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_lb_listener" "https_default" {
  load_balancer_arn = aws_lb.dead_simple_auth_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hello there! Welcome to dead simple auth!"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "ecs-rule" {

  listener_arn = aws_lb_listener.https_default.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_reverse_proxy.arn
  }

  condition {
    path_pattern {
      values = ["*/ecs*"]
    }
  }
}


resource "aws_security_group" "dead_simple_auth_alb_sg" {
  name        = "dead-simple-auth-alb-sg"
  description = "Allow all traffic"
  vpc_id      = var.create_vpc == true ? module.dead-simple-auth-vpc[0].vpc_id : var.vpc_id


  ingress {
    description = "Traffic from VPN"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

