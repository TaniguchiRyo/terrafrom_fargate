#ALB

locals {
  alb = {
    name               = "${var.project-name}-alb"
    idle_timeout       = 300
    internal           = false
    load_balancer_type = "application"
    security_groups = [
      module.http_sg.security_group_id,
      module.https_sg.security_group_id,
      module.http_redirect_sg.security_group_id
    ]
    subnets    = [aws_subnet.public-a.id, aws_subnet.public-c.id]
    log_bucket = aws_s3_bucket.alb_log.id
  }

  web-tg = {
    name     = "${var.project-name}-web-tg"
    port     = 80
    protocol = "HTTP"
    type     = "ip"
    healthcheck = {
      enabled             = true
      healthy_threshold   = 3
      interval            = 15
      matcher             = 200
      path                = "/healthcheck"
      port                = "traffic-port"
      protocol            = "HTTP"
      timeout             = 5
      unhealthy_threshold = 2
    }
  }

  #   web-listener-https = {
  #     load_balancer_arn        = aws_lb.alb.arn
  #     port                     = 443
  #     protocol                 = "HTTPS"
  #     ssl_policy               = "ELBSecurityPolicy-FS-1-2-2019-08"
  #     certificate_arn          = data.aws_acm_certificate.www.arn
  #     default_action_type      = "forward"
  #     default_target_group_arn = aws_lb_target_group.web-tg.arn
  #   }

  web-listener-http = {
    load_balancer_arn        = aws_lb.alb.arn
    port                     = 80
    protocol                 = "HTTP"
    default_action_type      = "forward"
    default_target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

resource "aws_lb" "alb" {
  name                       = local.alb["name"]
  idle_timeout               = local.alb["idle_timeout"]
  internal                   = local.alb["internal"]
  load_balancer_type         = local.alb["load_balancer_type"]
  security_groups            = local.alb["security_groups"]
  subnets                    = local.alb["subnets"]
  enable_deletion_protection = false

  access_logs {
    bucket  = local.alb["log_bucket"]
    enabled = true
  }

  tags = {
    Name = local.alb["name"]
  }

}

# target group
resource "aws_lb_target_group" "web-tg" {
  name        = local.web-tg["name"]
  port        = local.web-tg["port"]
  protocol    = local.web-tg["protocol"]
  target_type = local.web-tg["type"]

  vpc_id = aws_vpc.vpc_main.id

  health_check {
    enabled             = local.web-tg["healthcheck"].enabled
    healthy_threshold   = local.web-tg["healthcheck"].healthy_threshold
    interval            = local.web-tg["healthcheck"].interval
    matcher             = local.web-tg["healthcheck"].matcher
    path                = local.web-tg["healthcheck"].path
    port                = local.web-tg["healthcheck"].port
    protocol            = local.web-tg["healthcheck"].protocol
    timeout             = local.web-tg["healthcheck"].timeout
    unhealthy_threshold = local.web-tg["healthcheck"].unhealthy_threshold
  }

  tags = {
    Name = local.web-tg["name"]
  }
}

# listener
resource "aws_lb_listener" "alb-http" {
  load_balancer_arn = local.web-listener-http["load_balancer_arn"]
  port              = local.web-listener-http["port"]
  protocol          = local.web-listener-http["protocol"]

  # default_action {
  #   type = "fixed-response"

  #   fixed_response {
  #     content_type = "text/plain"
  #     message_body = "これは『HTTP』です"
  #     status_code  = "200"
  #   }
  # }
  default_action {
    type             = local.web-listener-http["default_action_type"]
    target_group_arn = local.web-listener-http["default_target_group_arn"]
  }
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
