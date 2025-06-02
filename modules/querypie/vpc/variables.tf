variable  "cidr_numeral" {
    description = "The VPC CIDR numeral (10.x.0.0/16)"
}

variable  "aws_region" {
    description = "tfvars code file apse2"
}

variable  "vpc_name" {
    description = "The name of the VPC"
}

variable  "availability_zones" {
    description = "tfcars code file apse1a"
}

variable "cidr_numeral_private" {
  default = {
    "0" = "0"
    "1" = "2"
    "2" = "4"
  }
}

variable "cidr_numeral_public" {
  default = {
    "0" = "10"
    "1" = "16"
    "2" = "24"
  }
}