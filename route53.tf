resource "aws_route53_record" "dns-name_components" {
  zone_id = var.PRIVATE_HOSTED_ZONE_ID
  name    = "${local.TAG_NAME}.roboshop.internal"
  type    = "A"
  ttl     = 300
  records = [aws_eip.lb.public_ip]
}