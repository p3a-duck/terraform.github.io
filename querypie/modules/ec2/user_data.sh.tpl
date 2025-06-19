#!/bin/bash
 export http_proxy="http://${bastion_ip}:3128"
 export https_proxy="http://${bastion_ip}:3128"
 echo "proxy=http://${bastion_ip}:3128" >> /etc/dnf/dnf.conf

 dnf install -y docker
 mkdir -p /etc/systemd/system/docker.service.d

 cat <<EOT > /etc/systemd/system/docker.service.d/http-proxy.conf
 [Service]
 Environment="HTTP_PROXY=http://${bastion_ip}:3128/"
 Environment="HTTPS_PROXY=http://${bastion_ip}:3128/"
 Environment="NO_PROXY=localhost,127.0.0.1"
 EOT

