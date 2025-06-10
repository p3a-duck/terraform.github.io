#bastion host ec2

resource "aws_instance" "bastion_instance" {
  ami           = var.aws_ami
  instance_type = "t2.micro"
  key_name      = "qpkey"
  subnet_id     = var.pub_sbn_id
  vpc_security_group_ids = var.alw_qp_sg_id
}

#bastion host eip
resource "aws_eip" "bastion_eip" {
  domain = "vpc"
  tags = {
    name = var.bastion_eip_name
  }
}

#querypie ec2
resource "aws_instance" "qp_instance" {
  ami		= var.aws_ami
  instance_type = "m5.large"
  key_name      = "qpkey"
  subnet_id     = var.priv_sbn_id
  vpc_security_group_ids = var.alw_ssh_sg_id
}

