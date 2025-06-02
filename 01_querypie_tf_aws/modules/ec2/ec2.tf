resource "aws_instance" "bastion_ec2" {
    ami = "ami-0afc7fe9be84307e4"
    instance_type = "m5.large"
    key_name = "qpkey"
    subnet_id = ""

}