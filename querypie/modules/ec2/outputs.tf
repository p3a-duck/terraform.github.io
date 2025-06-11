output "bastion_eip_id" {
  value = aws_eip.bastion_eip.id
}

output "bastion_ec2_id" {
  value = aws_instance.bastion_instance.id
}

