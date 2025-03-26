########################################
# Application Load Balancer (ALB)
########################################
# The ALB is public by default, as indicated by the `internal = false` setting
resource "aws_lb" "main" {
  name               = format("%s-alb", var.name)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.subnets
}

########################################
# Security Group for ALB
########################################
# This security group allows HTTP and HTTPS traffic to the ALB
# Note that ingress rules are open to all IPs (0.0.0.0/0), which may not be suitable for all use cases
# Modify the CIDR blocks if you need to restrict access
resource "aws_security_group" "lb" {
  name   = format("%s-alb-sg", var.name)
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

##################################
# Listeners for ALB
##################################
# Note that the listeners are defined for both HTTP and HTTPS traffic
# Delete either of these if your application doesn't need them, but you need at least one
# HTTPS listener is only created if a certificate ARN is provided
# Also, When you provide a certificate, HTTP listener redirects the traffict to HTTPS
resource "aws_lb_listener" "https" {
  # Only created if a certificate ARN is provided
  count = var.certificate_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    # Redirect to HTTPS if there is a certificate
    type = var.certificate_arn != "" ? "redirect" : "forward"
    dynamic "redirect" {
      for_each = var.certificate_arn != "" ? [1] : []

      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    # If there is no certificate, it is forwarded to the destination group
    target_group_arn = var.certificate_arn != "" ? null : aws_lb_target_group.main.arn
  }
}

##################################
# Target Group
##################################
# Health checks are configured to ensure that only healthy instances receive traffic
# If you need to adjust the number of checks required for an instance to be considered healthy or unhealthy, 
# modify the `healthy_threshold` and `unhealthy_threshold` values ​​in this configuration
resource "aws_lb_target_group" "main" {
  name        = format("%s-alb-target", var.name)
  port        = var.target_port
  protocol    = var.target_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
