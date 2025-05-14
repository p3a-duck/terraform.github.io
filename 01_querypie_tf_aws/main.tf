#provider
provider "aws" {
    region = "ap-southeast-1"
}

#module
module "vpc" {
	source  = "./modules/vpc"
	
	vpc_name = "QueryPie"
	cidr_numeral = "0"
	aws_region = "ap-southeast-1"
	availability_zones = ["ap-southeast-1a","ap-southeast-1c"]

}

module "security_group" {
	source  = "./modules/sg"
	vpc_id  = module.vpc.vpc_id
}
