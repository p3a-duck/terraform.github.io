resource "aws_security_group" "allow_querypie" {
  name        = "allow_querypie"
  description = "Allow Querypie inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_querypie_justin"
  }
}

/*
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

resource "aws_vpc_security_group_ingress_rule" "allow_querypie_icmp" {
  security_group_id = aws_security_group.allow_querypie.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1                 
  to_port           = -1
  ip_protocol       = "icmp"
}

#egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  ip_protocol       = "-1"
  to_port           = 0
}*/
