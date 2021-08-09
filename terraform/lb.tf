resource "aws_alb" "alb" {
  name               = local.lb["name"]
  internal           = local.lb["internal"]
  load_balancer_type = "application"
  subnets            = aws_subnet.subnet_public.*.id
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "group" {
  name        = local.lb.target_group["name"]
  port        = local.lb.target_group["port"]
  protocol    = local.lb.target_group["protocol"]
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  depends_on = [aws_alb.alb]
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.group.arn
  }
}