#//adding the frontend end instance target grp to public lb
#resource "aws_lb_listener" "front_end" {
#  count = var.LB_TYPE == "public" ? 1 : 0
#  load_balancer_arn = var.LB_ARN
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = "arn:aws:acm:us-east-1:124374336606:certificate/534f69be-bcc8-444e-9eb3-973a2f0d10d3"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.target-grp.arn
#  }
#}


//adding the backend instances target grp to private lb
#resource "aws_lb_listener" "backend" {
#  count = var.LB_TYPE == "private" ? 1 : 0
#  load_balancer_arn = var.LB_ARN
#  port              = "80"
#  protocol          = "HTTP"
#
#  default_action {
#    type = "fixed-response"
#
#    fixed_response {
#      content_type = "text/plain"
#      message_body = "Fixed response content"
#      status_code  = "200"
#    }
#  }
#}

resource "random_integer" "priority" {
  min = 1
  max = 50000
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = var.PRIVATE_LISTENER_ARN
  priority     = random_integer.priority.result

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-grp.arn
  }

  condition {
    host_header {
      values = ["${var.COMPONENT}-${var.ENV}-roboshop.internal"]
    }
  }
}
