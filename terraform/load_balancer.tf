
resource "aws_lb" "ecs-alb" {
  name               = "ecs-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
}

resource "aws_alb_target_group" "ecs_target_group" {
  name     = "ecs-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.ecs-alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate.certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_target_group.arn
  }
}

resource "aws_lb_listener" "alb-redirection-listener" {
  load_balancer_arn = aws_lb.ecs-alb.arn
  port              = 80
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
