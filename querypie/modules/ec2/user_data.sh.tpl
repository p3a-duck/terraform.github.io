#!/bin/bash
echo "proxy = http://${bastion_ip}:3128" >> /home/ec2-user/.curlrc
chown ec2-user:ec2-user /home/ec2-user/.curlrc
echo "proxy=http://${bastion_ip}:3128" >> /etc/dnf/dnf.conf

sleep 40 

log="/home/ec2-user/count.i"
echo "START USERDATA" >> "$log"

for i in {1..5}; do
  echo "🌐 [패키지 다운로드 카운트 $i] downloading script..." >> "$log"
  curl --proxy "http://${bastion_ip}:3128" -fL https://raw.githubusercontent.com/querypie/tpm/refs/heads/main/poc-install/poc-install.sh -o /home/ec2-user/poc-install.sh
  exit_code=$?
  echo "코드 반환: $exit_code" >> "$log"

  if [ $exit_code -eq 0 ]; then
    echo "✅ $i 번째 다운로드 성공" >> "$log"
    chmod +x /home/ec2-user/poc-install.sh
    echo "❗️Usage: poc-install.sh <version> >> "$log"
    break
  else
    echo "❌ $i 번째 다운로드 실패 " >> "$log"
    sleep 5
  fi
done




chmod +x /home/ec2-user/poc-install.sh

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

echo "user-data script finished" >> /var/log/user-data.log
