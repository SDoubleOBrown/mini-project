#Domain variable
variable "domain_name" {
  default    = "browndomains.com"
  type        = string
  description = "Domain name"
}

#Route 53 hosted zone
resource "aws_route53_zone" "hosted_zone" {
  name     = var.domain_name
}
#route 53 nameservers
resource "aws_route53_record" "nameservers" {
  allow_overwrite = true
  name            = var.domain_name
  ttl             = 3600
  type            = "NS"
  zone_id         = aws_route53_zone.hosted_zone.zone_id

  records = aws_route53_zone.browndomains.name_servers
}
#route 53 A record
resource "aws_route53_record" "record"{
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name = "terraform-test.${var.domain_name}"
  type = "A"

  alias {
    name = aws_lb.myloadbalancer.dns_name
    zone_id = aws_lb.myloadbalancer.zone_id
    evaluate_target_health = true
  }
}
