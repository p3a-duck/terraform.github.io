output "allow_querypie_sg_id" {
    value = aws_security_group.allow_querypie.id
}

output "allow_ssh_sg_id" {
  value = aws_security_group.allow_ssh.id
}

