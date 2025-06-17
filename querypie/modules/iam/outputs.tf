output "querypie_profile_name" {
  value = aws_iam_instance_profile.qp_profile.name
}

output "bastion_profile_name" {
  value = aws_iam_instance_profile.bst_profile.name
}
