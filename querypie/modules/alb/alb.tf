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
    path                = "/"
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
