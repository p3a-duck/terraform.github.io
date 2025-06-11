#bastion host ec2

resource "aws_instance" "bastion_instance" {
  ami           = var.aws_ami
  instance_type = "t2.micro"
  key_name      = "qpkey"
  subnet_id     = var.pub_sbn_id
  vpc_security_group_ids = var.alw_qp_sg_id
  tags = {
	name = "qp_bst_svr"
  }
}

#bastion host eip
resource "aws_eip" "bastion_eip" {
  domain = "vpc"
  tags = {
    name = var.bastion_eip_id
  }
}

#eip associaction bastion host
resource "aws_eip_association" "bastion_eip_association" {
  instance_id   = aws_instance.bastion_instance.id
  allocation_id = aws_eip.bastion_eip.id
}

#querypie ec2
resource "aws_instance" "qp_instance" {
  ami		= var.aws_ami
  instance_type = "m5.large"
  key_name      = "qpkey"
  subnet_id     = var.priv_sbn_id
  vpc_security_group_ids = var.alw_ssh_sg_id
  tags = {
	name = "querypie_svr_justin"
  }
}

