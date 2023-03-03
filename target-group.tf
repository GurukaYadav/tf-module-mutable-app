resource "aws_lb_target_group" "target-pub-grp" {
  name     = "${var.COMPONENT}-${var.ENV}-pub-tg"
  port     = var.PORT
  protocol = "HTTP"
  vpc_id   = var.VPC_ID

  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 2
    path = /health
    interval = 7
    timeout = 6
  }
}

//attaching instances to target group
resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.target-pub-grp.arn
  target_id        = aws_spot_instance_request.instance.*.spot_instance_id
  port             = var.PORT
}


