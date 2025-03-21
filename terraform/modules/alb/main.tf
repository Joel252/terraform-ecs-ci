############################
# ALB
############################

resource "aws_lb" "main" {
  name               = format("%s-alb", var.name)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security.id]
  subnets            = var.subnets
}

############################
# Security Group
############################

resource "aws_security_group" "security" {
  name   = format("%s-security", var.name)
  vpc_id = var.vpc_id

  ingress {
    description = "Allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# Listeners
############################

resource "aws_lb_listener" "https" {
  count = var.certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = var.certificate_arn != "" ? "redirect" : "forward"
    dynamic "redirect" {
      for_each = var.certificate_arn != "" ? [1] : []

      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    target_group_arn = var.certificate_arn != "" ? null : aws_lb_target_group.target.arn
  }
}

############################
# Target Group
############################

resource "aws_lb_target_group" "target" {
  name     = format("%s-target", var.name)
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
