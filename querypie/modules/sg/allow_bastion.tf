resource "aws_security_group" "allow_ssh" {
  name        = "allow_bastion"
  description = "Allow SSH access to the bastion server"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_ssh_justin"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_22" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_ingress_rule" "allow_443" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
