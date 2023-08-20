// load balancer
resource "aws_lb" "load_balancer" {
  name               = "mirza-alb-${terraform.workspace}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnet_ids.default_subnets.ids
}

// load balancer listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

// load balancer listener rules
resource "aws_lb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

// load balancer target group
resource "aws_lb_target_group" "alb_target_group" {
  name     = "mirza-alb-tg-${terraform.workspace}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

// load balancer target group instance attachment -> ec2 instance
resource "aws_lb_target_group_attachment" "alb_target_group_attachment_1" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.instance[0].id
  port             = 80
}

// load balancer target group instance attachment -> ec2 instance
resource "aws_lb_target_group_attachment" "alb_target_group_attachment_2" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.instance[1].id
  port             = 80
}
