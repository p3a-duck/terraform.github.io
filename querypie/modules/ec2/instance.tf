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

#Proxy(Squid) 설치 및 설정
  user_data = <<EOF
#!/bin/bash
set -e
yum install -y squid
  
cat > /etc/squid/squid.conf <<EOL
acl localnet src 10.0.0.0/8
http_access allow localnet
http_port 3128
EOL
 
systemctl enable squid
systemctl restart squid
EOF


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
#user_data.sh.tpl파일 참조
#docker설치 및 docker proxy 설정
  user_data = templatefile("${path.module}/user_data.sh.tpl" , {bastion_ip = aws_instance.bastion_instance.private_ip
  })

  /* #!/bin/bash  
  sudo export http_proxy=http://${aws_instance.bastion_instance.private_ip}:3128
  sudo export https_proxy=http://${aws_instance.bastion_instance.private_ip}:3128
  sudo echo "proxy=http://${aws_instance.bastion_instance.private_ip}:3128" | sudo tee -a /etc/dnf/dnf.conf
  sudo dnf install -y docker
  sudo mkdir -p /etc/systemd/system/docker.service.d
  sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null <<EOF
  [Service]
  Environment="HTTP_PROXY=http://10.0.83.91:3128/"
  Environment="HTTPS_PROXY=http://10.0.83.91:3128/"
  Environment="NO_PROXY=localhost,127.0.0.1"
  EOF 
 */
}

