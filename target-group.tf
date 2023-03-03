resource "aws_lb_target_group" "target-grp" {
  name     = "${var.COMPONENT}-${var.ENV}-tg"
  port     = var.PORT
  protocol = "HTTP"
  vpc_id   = var.VPC_ID

  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    path = "/health"
    interval = 7
    timeout = 6
  }
}

#attaching instances to target group
resource "aws_lb_target_group_attachment" "attach" {
  count = var.INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.target-grp.arn
  target_id        = aws_spot_instance_request.instance.*.spot_instance_id[count.index]
  port             = var.PORT
}


