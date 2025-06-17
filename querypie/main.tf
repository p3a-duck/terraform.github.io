module "vpc" {
  source = "./modules/vpc"
#  cidr_numeral       = var.cidr_numeral
  aws_region         = var.aws_region
  vpc_name           = var.vpc_name
  availability_zones = var.availability_zones
  cidr_numeral_public  = var.cidr_numeral_public
  cidr_numeral_private = var.cidr_numeral_private
}

module "iam" {
  source = "./modules/iam"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}


module "instance" {
  source = "./modules/ec2"
  bastion_eip_id = var.bastion_eip_id
  aws_ami = var.aws_ami
  pub_sbn_id = module.vpc.pub_sbn_ids[0]
  priv_sbn_id = module.vpc.priv_sbn_ids[0]
  alw_qp_sg_id = [module.sg.allow_querypie_sg_id]
  alw_ssh_sg_id = [module.sg.allow_ssh_sg_id]
  ec2_profile_name = module.iam.querypie_profile_name
  bastion_profile_name = module.iam.bastion_profile_name
}

module "alb" {
  source = "./modules/alb"
  pub_sbn_id = module.vpc.pub_sbn_ids
  alw_qp_sg_id = [module.sg.allow_querypie_sg_id]
  vpc_id = module.vpc.vpc_id
  target_id = module.instance.qp_instance_id
}
