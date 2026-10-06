resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name        = "${var.environment}-route53-zone"
    Environment = var.environment
  }
}

resource "aws_route53_record" "petclinic" {
  zone_id = aws_route53_zone.main.zone_id

  name = "${var.subdomain}.${var.domain_name}"
  type = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}