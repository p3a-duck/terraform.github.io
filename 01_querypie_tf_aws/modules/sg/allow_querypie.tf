resource "aws_security_group" "allow_querypie" {
  name        = "allow_querypie"
  description = "Allow Querypie inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_querypie"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_querypie_ssh" {
  security_group_id = aws_security_group.allow_querypie.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_querypie_http" {
    security_group_id = aws_security_group.allow_querypie.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 80
    ip_protocol       = "tcp"
    to_port           = 80
  }

  resource "aws_vpc_security_group_ingress_rule" "allow_querypie_https" {
    security_group_id = aws_security_group.allow_querypie.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 443
    ip_protocol       = "tcp"
    to_port           = 443
  }

  resource "aws_vpc_security_group_ingress_rule" "allow_querypie_proxy" {
    security_group_id = aws_security_group.allow_querypie.id
    cidr_ipv4         = "0.0.0.0/0"
    from_port         = 9000
    ip_protocol       = "tcp"
    to_port           = 9000
  }