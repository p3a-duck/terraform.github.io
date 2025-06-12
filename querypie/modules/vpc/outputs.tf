output "vpc_id" {
    value = aws_vpc.main.id
}

# public subnet ID 목록 출력
output "pub_sbn_ids" {
  value = aws_subnet.pub_sbn[*].id
}

# private subnet ID 목록 출력
output "priv_sbn_ids" {
  value = aws_subnet.priv_sbn[*].id
}

# region 출력
output "aws_region" {
  value = var.aws_region
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block 
}
