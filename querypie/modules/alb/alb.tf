resource "aws_lb" "this" {
  name               = "querypie-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups    = var.alw_qp_sg_id
  subnets            = var.pub_sbn_id

  enable_deletion_protection = false

  tags = {
    Name = "qp-alb"
  }
}

resource "aws_lb_target_group" "qp_tg" {
  name     = "querypie-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/readyz"
    protocol            = "HTTPS"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "qp-tg"
  }
}

resource "aws_lb_target_group_attachment" "qp_tg_att" {
  target_group_arn = aws_lb_target_group.qp_tg.arn
  target_id        = var.target_id   # EC2 인스턴스 ID
  port             = 80
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = "arn:aws:acm:ap-southeast-1:991717212341:certificate/0b798737-0c53-4901-93b6-1d48b5570f51"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.qp_tg.arn
  }
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
