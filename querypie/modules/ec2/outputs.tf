output "bastion_eip_id" {
  value = aws_eip.bastion_eip.id
}

output "bastion_ec2_id" {
  value = aws_instance.bastion_instance.id
}

output "qp_instance_id" {
  value = aws_instance.qp_instance.id
}

output "bastion_private_ip" {
  value = aws_instance.bastion_instance.private_ip
}

