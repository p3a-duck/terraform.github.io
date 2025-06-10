variable "region_apse1" {
  default = "ap-southeast-1"
}

#VPC variable
variable "vpc_id" {
  description = "vpc id"
  type        = string
  default     = "aws_vpc.main.id"
}

variable "cidr_numeral" {
  description = "The VPC CIDR numeral (10.x.0.0/16)"
}

variable "vpc_name" {
  description = "This is querypie vpc name"
  default     = "querypie"
}


variable "aws_region" {
  description = "tfvars code file apse1"
  default     = "ap-southeast-1"
}


variable "availability_zones" {
  description = "tfvars code file apse1a"
  default     = ["ap-southeast-1a", "ap-southeast-1c"]
}

variable "cidr_numeral_private" {
  type = map
  default = {
    "0" = "0"
    "1" = "16"
    "2" = "32"
  }
}

variable "cidr_numeral_public" {
  type = map
  default = {
    "0" = "80"
    "1" = "96"
    "2" = "112"
  }
}

#EC2
variable "bastion_eip_name" {
  description = "Name tag for the EIP"
  type        = string
  default     = "querypie_eip_justin"
}

variable "aws_ami" {
  description = "ami-0afc7fe9be84307e4"
  type        = string
  default     = "ami-0afc7fe9be84307e4"
}
