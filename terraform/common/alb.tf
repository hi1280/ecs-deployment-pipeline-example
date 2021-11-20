resource "aws_lb" "ecs_deploy" {
  name                       = "ecs-deploy-alb"
  internal                   = false
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  drop_invalid_header_fields = true
  security_groups = [
    aws_security_group.alb.id,
  ]
  subnets = [
    for subnet in aws_subnet.public : subnet.id
  ]
  enable_deletion_protection = false
  tags = {
    Name = "ecs-deploy-alb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs_deploy.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ecs_deploy.arn
  certificate_arn   = aws_acm_certificate.cert.arn
  port              = 443
  protocol          = "HTTPS"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "403 Forbidden"
      status_code  = 403
    }
  }
}