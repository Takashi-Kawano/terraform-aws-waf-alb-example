variable "alb_name" {
    description = "The resource name of the alb."
}

variable "alb_tg_name" {
    description = "The resource name of the alb's target group."
}

variable "alb_sg_name" {
    description = "The resource name of the alb's security group."
}

variable "ec2_name" {
    description = "Name tag of the ec2."
}

variable "ec2_ami" {
    description = "AMI of the ec2."
}

variable "ec2_instance_type" {
    description = "instance type of the ec2."
}

variable "ec2_sg_name" {
    description = "The resource name of the ec2's security group'."
}

variable "vpc_cidr_block" {
    description = "cidr block of vpc'."
}

variable "public1_subnet_cidr_block" {
    description = "This is a network for placing a NAT gateway. Also used for ALB's Multi-AZ."
}

variable "public2_subnet_cidr_block" {
    description = "Used for ALB's Multi-AZ."
}

variable "private_subnet_cidr_block" {
    description = "This is a network for placing a ec2."
}

variable "public1_subnet_availability_zone" {
    description = "AZ used in public1 subnet."
}

variable "public2_subnet_availability_zone" {
    description = "AZ used in public2 subnet. Specify something diffrent from public1_subnet_availability_zone"
}

variable "private_subnet_availability_zone" {
    description = "AZ used in private subnet"
}

variable "allow_ip" {
    description = "IP allowd in waf rule"
}
