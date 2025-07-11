#!/bin/bash
echo "proxy = http://${bastion_ip}:3128" >> /home/ec2-user/.curlrc
chown ec2-user:ec2-user /home/ec2-user/.curlrc
echo "proxy=http://${bastion_ip}:3128" >> /etc/dnf/dnf.conf

sleep 80 

log="/home/ec2-user/count.i"
echo "START USERDATA" >> "$log"

for i in {1..5}; do
  echo "🌐 [패키지 다운로드 카운트 $i] downloading script..." >> "$log"
  curl --proxy "http://${bastion_ip}:3128" -fL https://raw.githubusercontent.com/querypie/tpm/refs/heads/main/poc-install/poc-install.sh -o /home/ec2-user/poc-install.sh
  exit_code=$?
  echo "🚫exit code: $exit_code" >> "$log"

  if [ $exit_code -eq 0 ]; then
    echo "✅ $i 번째 다운로드 성공" >> "$log"
    chmod +x /home/ec2-user/poc-install.sh
    echo "❗️Usage: poc-install.sh <version>" >> "$log"
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

cat > /home/ec2-user/partner.crt << EOF
-----BEGIN CERTIFICATE-----
MIID/jCCAuagAwIBAgIBATANBgkqhkiG9w0BAQsFADBLMQswCQYDVQQGEwJLUjEO
MAwGA1UECAwFU2VvdWwxFjAUBgNVBAoMDUNIRVFVRVIsIEluYy4xFDASBgNVBAMM
C1F1ZXJ5cGllIENBMB4XDTI0MTIyMjE1MDAwMFoXDTI1MTIzMTE0NTk1OVowYTEL
MAkGA1UEBhMCS1IxGjAYBgNVBAoMEXBhcnRuZXJzX2RhY19uX2RkMREwDwYDVQQD
DAhRdWVyeVBpZTEjMCEGA1UEDAwaUXVlcnlQaWUgQUlERDtRdWVyeVBpZSBEQUMw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCbGL7raKU6I+RP+nyzkvSe
3OjwcwR0b2BiyVf+m89URbqOO8IHv/p/IMPTvvxJJcY/GSr2OSfa/u4qaY5XhRFL
GWPy8vsobfYvNpx+LDvpNH5OYI7CT+zeE7randniBcPf6rcXVDvRZnfkbyEAfdAU
fPYvD4u1Bemgy2TmNfxWjs3ad+q3sHdAV8L6Pkt4uqcJsPpCPFm6/mlu3Eycz49Z
ODEhIdwzydKsGgEj35IS0yQpeVLUEh3DE8kPYeg5/bYZqCID2WmZh0qc8LEljLIV
aPDpU/OPH7rfSC1lLfMraYNwDKsFNfXwdcLYdyRWKn12ZpoOOj0cVVAwMf9ikVfJ
AgMBAAGjgdYwgdMwCQYDVR0TBAIwADAdBgNVHQ4EFgQU9hEc0Zf4PhuJtgO/AeIr
HY1ZS7cwJAYGKwYBBAABBBpRdWVyeVBpZSBBSUREO1F1ZXJ5UGllIERBQzAUBgYr
BgEEAAIECkVudGVycHJpc2UwDQYGKwYBBAADBANQb0MwIQYGKwYBBAAEBBcyMDI0
LTEyLTIzIDAwOjAwOjAwIEtTVDAhBgYrBgEEAAUEFzIwMjUtMTItMzEgMjM6NTk6
NTkgS1NUMAoGBisGAQQABgQAMAoGBisGAQQACwQAMA0GCSqGSIb3DQEBCwUAA4IB
AQBcPff5ZpsDV1TpKb9MROWNL+KrV6csg/Slp6mgPOK8aR7Mimop2PKRa8vdSgng
FOu6D5KsnCgjpSfN4ULgMT+2NhDNVedkM4N3YmVLuBUo0V5++D9tkI9fv2D6wuHo
7L4NEcIWxngm/15rv7WIoPAJMkVOzGcajN5H3XEO/yC5CcwmiwNwBqqIe6oaj2vx
U0ITNolNPom4swbAgSDIh+/ekntAz3QpI0sgy9+XXPPSARKROq6wpYJAU461jPwG
uFB82ZDoVkN7kdB0MosaqhgHGFXYlFdqQtgrIkPMmstHRMuU+wulaEhox08zEwkw
EU1Z1rnyY4+1I7VC/5x4Pt8A
-----END CERTIFICATE-----
EOF
