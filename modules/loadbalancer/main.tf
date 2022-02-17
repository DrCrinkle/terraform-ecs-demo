resource "aws_lb" "nlb" {
  name               = "taylor-lb-ecs"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets

}

resource "aws_lb_target_group" "test" {
  name     = "taylor-ecs-example-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
