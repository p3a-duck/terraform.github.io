#create vpc
#vpc id = vpc-0983fe081bd19d9d6
resource "aws_vpc" "main" {
	cidr_block = "10.0.0.0/16"

	tags = {
		Name = var.vpc_name
	}
}


#create private subnet (10.0.0.0/24, 10.0.2.0/24)
#subnetid = subnet-0135536332d8554a2
resource "aws_subnet" "priv_sbn" {
	count = length(var.availability_zones)
	vpc_id	= aws_vpc.main.id
	cidr_block  = "10.${var.cidr_numeral}.${var.cidr_numeral_private[count.index]}.0/22"

	availability_zone = element(var.availability_zones, count.index)

	tags = {
                Name = "qp-pri-sbn-apse1-${substr(element(var.availability_zones, count.index), -1, 1)}"
        }
}

#create public subnet (10.0.10.0/24, 10.0.16.0/24)
#subnetid = subnet-0851c7738e573371e
resource "aws_subnet" "pub_sbn" {
	count = length(var.availability_zones)	
    vpc_id  = aws_vpc.main.id
    cidr_block  = "10.${var.cidr_numeral}.${var.cidr_numeral_public[count.index]}.0/22"

	availability_zone = element(var.availability_zones, count.index)

        tags = {
                Name = "qp-pub-sbn-apse1-${substr(element(var.availability_zones, count.index), -1, 1)}"
        }
}

#create igw
resource "aws_internet_gateway" "igw" {
		vpc_id = aws_vpc.main.id
		tags = {
				Name = "qp-igw"			
		}
}

#create public route_table
#routing table id = rtb-0079169a4711ef20d
resource "aws_route_table" "public" {
		vpc_id = aws_vpc.main.id
		tags = {
				Name = "qp-rt-pub"
		}
}

#add public route to igw
resource "aws_route" "public_igw" {
		route_table_id	= aws_route_table.public.id
		destination_cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id

}


#create public route_table_association
resource "aws_route_table_association" "public" {
	count = length(var.availability_zones)
	subnet_id = element(aws_subnet.pub_sbn.*.id, count.index)
	route_table_id = aws_route_table.public.id
}

#create priv route_table
#routing table id = rtb-045759e0b6ec9b5da
resource "aws_route_table" "private" {
		vpc_id = aws_vpc.main.id
		tags = {
				Name = "qp-rt-priv"
		}
}


#add private route to igw  임시
resource "aws_route" "private_igw" {
		route_table_id	= aws_route_table.private.id
		destination_cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id

}


#craete priv route_table_association
resource "aws_route_table_association" "private" {
	count = length(var.availability_zones)
	subnet_id = element(aws_subnet.priv_sbn.*.id, count.index)
	route_table_id = aws_route_table.private.id
}

