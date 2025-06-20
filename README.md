# terraform.github.io
This github repo is basic architecture for querypie


	## 생성되는 리소스##

### 📦 VPC 구성
- **1** VPC
  - 10.x.0.0/16
- **2** Subnet
  - public subnet
  - private subnet
- **1** Internet Gateway (IGW)
- **1** Elastic IP (EIP)
- **2** Security Group
  - allow_ssh
  	- 22
	- 443
	- icmp
	- 3128 (squid)
  - allow_querypie
	- 443
  	- 22
  	- 9000
  	- icmp

### 🖥️ EC2 인스턴스
- **2** EC2 Instance
  - Bastion Server(pub sbn)
	- 쿼리파이 서버의 http,https 통신을 위한 squid proxy 설정
  - QueryPie Server(pri sbn)
	- 도커 및 쿼리파이 설치를 위한 프록시 설정(user_data.sh.tpl 참조)
	- 쿼리파이 poc_install.sh 파일 자동 다운로드

### ⚖️ 로드 밸런서
- **1** Application Load Balancer (ALB)
- **2** Listener
- **1** Target Group

### 🔐 IAM
- **1** IAM Role 
  - DB Sync Role


### 🗝️  사용 방법
1. keypair 변경방법
  - /module/ec2/instance.tf
    - key_name 변경 (ex, key_name = "keyname")
2. 쿼리파이 서버 접속방법
  - bastion 서버 접속 > 쿼리파이 서버 접속
    - 인스턴스 생성시 설정한 키 사용(1번 항목 참조)
