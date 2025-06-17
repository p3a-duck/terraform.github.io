#bastion host ec2

resource "aws_instance" "bastion_instance" {
  ami           = var.aws_ami
  instance_type = "t2.micro"
  key_name      = "qpkey"
  subnet_id     = var.pub_sbn_id
  vpc_security_group_ids = var.alw_ssh_sg_id
  tags = {
	Name = "qp_bst_svr_justin"
  }
  iam_instance_profile   = var.bastion_profile_name
}

#bastion host eip
resource "aws_eip" "bastion_eip" {
  domain = "vpc"
  tags = {
    Name = "bst_eip_justin"
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
  vpc_security_group_ids = var.alw_qp_sg_id
  tags = {
	Name = "qp_svr_justin"
  }
  iam_instance_profile   = var.ec2_profile_name
  root_block_device {
    volume_size = 50        # 디스크 크기 (GB)
    volume_type = "gp3"     # 일반 SSD (필요 시 gp3 등으로 변경 가능)
    delete_on_termination = true
  }
}

