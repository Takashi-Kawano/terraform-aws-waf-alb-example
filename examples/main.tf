module "sample" {
    source  = "Takashi-Kawano/waf-alb-sample/aws"
    version = "1.0.2"

    alb_name    = "test"
    alb_tg_name = "test"
    alb_sg_name = "test_alb_sg"

    ec2_ami           = "ami-0f02b24005e4aec36"
    ec2_instance_type = "t3.micro"
    ec2_name          = "test_ec2"
    ec2_sg_name       = "test_ec2_sg"

    vpc_cidr_block            = "10.1.0.0/16"

    public1_subnet_cidr_block = "10.1.0.0/24"
    public2_subnet_cidr_block = "10.1.1.0/24"
    private_subnet_cidr_block = "10.1.2.0/24"

    public1_subnet_availability_zone = "ap-southeast-1a"
    public2_subnet_availability_zone = "ap-southeast-1c"
    private_subnet_availability_zone = "ap-southeast-1a"


    allow_ip = "127.0.0.1/32"
}

output "dns_name" {
    value = "${module.sample.dns_name}"
}
