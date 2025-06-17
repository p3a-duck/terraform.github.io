output "vpc_id" {
    value = module.vpc.vpc_id
}

output "allow_querypie_sg_id" {
    value = module.sg.allow_querypie_sg_id
}

output "allow_ssh_sg_id" {
  value = module.sg.allow_ssh_sg_id
}


# public subnet ID 목록 출력
output "public_subnet_ids" {
  value = module.vpc.pub_sbn_ids
}

# private subnet ID 목록 출력
output "private_subnet_ids" {
  value = module.vpc.priv_sbn_ids
}


output "alb_id" {
  value = module.alb.alb_id
}

output "bastion_eip_id" {
  value = module.instance.bastion_eip_id
}

output "bastion_ec2_id" {
  value = module.instance.bastion_ec2_id
}

output "cidr_block" {
  value = module.vpc.cidr_block
}

output "qp_id" {
  value = module.instance.qp_instance_id
}

/*
# region 출력
output "aws_region" {
  value = var.aws_region
}
*/
