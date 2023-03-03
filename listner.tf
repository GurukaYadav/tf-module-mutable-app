//adding the frontend end instance target grp to public lb
resource "aws_lb_listener" "front_end" {
  count = var.LB_TYPE == "public" ? 1 : 0
  load_balancer_arn = var.LB_ARN
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:124374336606:certificate/534f69be-bcc8-444e-9eb3-973a2f0d10d3"

  default_action {
    type             = "forward-to-frontend"
    target_group_arn = aws_lb_target_group.target-grp.arn
  }
}