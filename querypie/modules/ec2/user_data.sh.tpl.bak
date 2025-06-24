#!/bin/bash
set -e
export http_proxy="http://${bastion_ip}:3128"
export https_proxy="http://${bastion_ip}:3128"
echo "proxy=http://${bastion_ip}:3128" >> /etc/dnf/dnf.conf

sleep 20

curl -L https://raw.githubusercontent.com/querypie/tpm/refs/heads/main/poc-install/poc-install.sh -o /home/ec2-user/poc-install.sh

dnf install -y docker
mkdir -p /etc/systemd/system/docker.service.d

cat <<EOT > /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://${bastion_ip}:3128/"
Environment="HTTPS_PROXY=http://${bastion_ip}:3128/"
Environment="NO_PROXY=localhost,127.0.0.1"
EOT

systemctl daemon-reload
systemctl enable docker
systemctl restart docker
