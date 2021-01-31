
resource "aws_ecs_service" "nginx_reverse_proxy" {
  name            = "dsa-nginx-reverse-proxy-service"
  cluster         = aws_ecs_cluster.dead_simple_auth_ecs_fargate.id
  task_definition = aws_ecs_task_definition.ecs_nginx_reverse_proxy.arn
  desired_count   = 2
  #iam_role        = aws_iam_role.dsa_ecs_role.arn
  depends_on  = [aws_iam_role_policy.dsa_ecs_execution_role_policy, aws_iam_role.dsa_ecs_execution_role, aws_lb_target_group.nginx_reverse_proxy, aws_lb_listener_rule.ecs-rule]
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_reverse_proxy.arn
    container_name   = "dsa-nginx-reverse-proxy"
    container_port   = var.app_port
  }

  network_configuration {
    subnets         = var.create_vpc == true ? module.dead-simple-auth-vpc[0].private_subnets : var.private_subnets
    security_groups = [aws_security_group.dsa_ecs_sg.id]
    #TODO ensure nat gateway on private subnets for ECS
    assign_public_ip = false
  }
}

resource "aws_ecs_task_definition" "ecs_nginx_reverse_proxy" {
  family                   = "dsa-nginx-reverse-proxy"
  task_role_arn            = aws_iam_role.dsa_ecs_task_role.arn
  execution_role_arn       = aws_iam_role.dsa_ecs_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096
  container_definitions    = local.container_definitions
  depends_on               = [aws_lb_target_group.nginx_reverse_proxy]
}

resource "aws_ecs_cluster" "dead_simple_auth_ecs_fargate" {
  name               = "Dead-Simple-Auth-Fargate-ECS"
  capacity_providers = ["FARGATE"]
}
/*
resource "aws_ecs_task_definition" "nginx_ecs" {
  container_definitions = file("${path.module}/task-definitions/task-definition.json")
  family = "dead-simple-auth"
}*/

resource "aws_lb_target_group" "nginx_reverse_proxy" {
  name        = "nginx-reverse-proxy"
  port        = var.app_port
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.create_vpc == true ? module.dead-simple-auth-vpc[0].vpc_id : var.vpc_id
  depends_on  = [aws_lb.dead_simple_auth_alb]
}
/*
resource "aws_lb_target_group_attachment" "nginx_attach" {
  target_group_arn = aws_lb_target_group.nginx_reverse_proxy.arn
  target_id = aws_ecs_service.nginx_reverse_proxy.id
}
*/
resource "aws_iam_role" "dsa_ecs_execution_role" {
  name               = "dsa-nginx-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.assume_from_ecs.json
}

resource "aws_iam_role" "dsa_ecs_task_role" {
  name               = "dsa-nginx-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_from_ecs.json
}

resource "aws_iam_role_policy" "dsa_ecs_execution_role_policy" {
  name   = "dca-ecs-execution-role-policy"
  policy = data.aws_iam_policy_document.dsa_ecs_execution_policy.json
  role   = aws_iam_role.dsa_ecs_execution_role.id
}

resource "aws_iam_role_policy" "dsa_ecs_task_role_policy" {
  name   = "dsa-ecs-task-role-policy"
  policy = data.aws_iam_policy_document.dsa_ecs_task_policy.json
  role   = aws_iam_role.dsa_ecs_task_role.id
}

resource "aws_security_group" "dsa_ecs_sg" {
  name        = "dead-simple-auth-ecs-sg"
  description = "Allow all traffic"
  vpc_id      = var.create_vpc == true ? module.dead-simple-auth-vpc[0].vpc_id : var.vpc_id


  ingress {
    description     = "Traffic from ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.dead_simple_auth_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "dsa_log_group" {
  #TODO - parameterize this with variables
  name              = "/ecs/dsa-nginx-reverse-proxy"
  retention_in_days = 1

  tags = {
    Name = "dsa-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "dsa_log_stream" {
  name           = "dsa-log-stream"
  log_group_name = aws_cloudwatch_log_group.dsa_log_group.name
}
