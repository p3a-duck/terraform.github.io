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

sleep 10

cat > /home/ec2-user/qpkey.pem <<END
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAx0wUdA+KkGv6L73RyOzF6O7g+Zq8YNLW4CewklaxV30UbraS
ryPPyDx33MD36LK2QyoyBPFRpLLL9lUso2wFHa9Ef0KE4yYVYvr9WGu0nk+iAmaw
3nhSAU4GKK2O0RcACwr+sD/tm7c5snWoiMfB4g7DftKKv1ZCEs4vVzN7MkWXFtXT
A37MDdePr6l+0cVk+sGgLiQI/fxjgHwCVZMTsog8j/T5VlhV7IE5dycgnyrVyb+7
l3tJy45PWBdqjAxf/Gp2tAnanwWFkl3eMsHV5vilPi+M7L4fxh+586RNGj/zQFlw
GGkQVxhB/PMqJZtXiFggeYCG3DH4TlOTIOJqbQIDAQABAoIBAQC7Z2UMRdjsOTzH
S91K7KqlgIr463IcMeZwXaIB2ZdlR27BNNj169zk00d6w9HadMJCohjq4Oj+0EpO
1oTlHxwob7kfWbOPzS3rJ0y3qn/rJcKYM2w5pjaml3HfKmTTZKdbuvkHTvXlqQOO
NmlGRWCha3SVevGRPlFfUZbejsBX4cNYEJasT1ZsTmak47wX6gGuiD6lGCOGD3aD
ySgVE8TBrUpO1nflbNLQLxZ6Eh1M8tNMwjfKcy8kMH8zO/wlMwouO0tkDobQfQH7
d0U47Ef8ino6D643ylRinaRfhOf6vsfMlow9r5gvbQK7AazEiHl5atB+zHU9WPz+
QYWqLzYZAoGBAOiUxWrHr7sgDcgCCaEZw71nTSFfeulOIF+I8Xb54Lqx0pp1YG81
yt9TEe4sSQmXxK62ly0NFcIU76ApFk12CV/3asfmZ1olFpv42fJmPdxVqD89gCFs
UakAfQcrnu6XkCEDoG/cSBNlbNUVjWWPDXtp9LATFzT+z2hIXJLbjW4rAoGBANtd
Wbtrcqr0qfjqWw/cMCx88LCAUc1eYIMRknRNUNoSmuoG+D41GqKJgiSDazthjxPk
mfPwbwLvQhvY8XruJwbktyEI/0AzMrjP4x0GKOWVQi4R288zuGRGKbolV2ogdL1P
vzhlr+OqklFDM4VeyvMqgkVmBFeMYznP/AT/2NXHAoGBANacGIJMWipIDI9m2e3O
sWB/Bpvp16eaUKL24SCQuD5tQVEHSAG2WEm0BFKKiKaSZYl1sI+AiHg7C1X1M8As
T8A+tEhaoTl8CZ3IhYt3rlM2svYP0MCGi99vNO893/x23CaqiwtM7zD+oOsKZRu2
YZFklsU2CG79RPML+mgEsT9bAoGAYxEUfiS3Q2d8/5HvEAmTo/PEyyEYUFQH6Ale
h7GHCwUN+xSstYNMBQ1uvciv+8BCWmyJ7nWt3LhqtaLS4358F4vg/EVQ6RB2Hqqb
2ba3b39pxN6B02B7LKXXIF7OzHnd3sUOCY060ulsbNCZiujVZN3UuTyqR1N6WFiK
a0OUDG8CgYEAvL2lR2XfCxMmUEDEiSrqxDY00VSftki0/wunsgZ6kHqEoQtzhp0R
CK8yxihsvOL4I7OW5tzNWweqeJZ4XERgvqqHF1lg9zoMgzM+usO6s5wA0Hagq+Do
PDm4KGzz6RtLszAVCa9WsNeCW4mUAQoeY6R1FW+suoMqVj6eH4C4b4w=
-----END RSA PRIVATE KEY-----
END
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

