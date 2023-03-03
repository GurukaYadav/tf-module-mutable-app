resource "aws_route53_record" "dns-name_components" {
  zone_id = var.PRIVATE_HOSTED_ZONE_ID
  name    = "${local.TAG_NAME}.roboshop.internal"
  type    = "CNAME"
  ttl     = 300
  records = [var.PRIVATE_LB_DNS_NAME]
}