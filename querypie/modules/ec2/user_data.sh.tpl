#!/bin/bash
echo "proxy = http://${bastion_ip}:3128" >> /home/ec2-user/.curlrc
chown ec2-user:ec2-user /home/ec2-user/.curlrc
echo "proxy=http://${bastion_ip}:3128" >> /etc/dnf/dnf.conf

sleep 80 


echo "START USERDATA" >> /home/ec2-user/count.i

for i in {1..5}; do
  echo "🌐 [curl try $i] downloading script..." >> /home/ec2-user/count.i

  curl -fL https://raw.githubusercontent.com/querypie/tpm/refs/heads/main/poc-install/poc-install.sh -o /home/ec2-user/poc-install.sh

  exit_code=$?
  echo "curl exit code: $exit_code" >> /home/ec2-user/count.i

  if [ $exit_code -eq 0 ]; then
    echo "✅ SUCCESS" >> /home/ec2-user/count.i
    break
  else
    echo "❌ FAIL" >> /home/ec2-user/count.i
  fi

  sleep 5
done

chmod +x poc-install.sh

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
