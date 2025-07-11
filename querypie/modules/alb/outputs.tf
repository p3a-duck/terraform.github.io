output "alb_id" {
  value = aws_lb.this.id
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}
