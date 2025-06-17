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
  - 443
  - 22
  - 9000
  - icmp

### 🖥️ EC2 인스턴스
- **2** EC2 Instance
  - Bastion Server(pub sbn)
  - QueryPie Server(pri sbn)

### ⚖️ 로드 밸런서
- **1** Application Load Balancer (ALB)
- **2** Listener
- **1** Target Group

### 🔐 IAM
- **1** IAM Role 
  - DB Sync Role

