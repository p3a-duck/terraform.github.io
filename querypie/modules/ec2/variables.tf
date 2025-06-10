variable "region_apse1" {
  default = "ap-souteast-1"
}

variable "bastion_eip_name" {
  description = "Name tag for the EIP"
  type        = string
}

variable "aws_ami" {
  description = "ami-0afc7fe9be84307e4"
  type        = string
}

variable "pub_sbn_id" {
  type = string
}

variable "priv_sbn_id" {
  type = string
}

variable "alw_qp_sg_id" {
  type = list(string)
  description = "necessary to querypie port"
}

variable "alw_ssh_sg_id" {
  type = list(string)
  description = "Open ssh port"
}
