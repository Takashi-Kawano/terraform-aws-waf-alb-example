resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public1" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public1_subnet_cidr_block}"
    map_public_ip_on_launch = true
    availability_zone = "${var.public1_subnet_availability_zone}"
}

resource "aws_subnet" "public2" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public2_subnet_cidr_block}"
    map_public_ip_on_launch = true
    availability_zone = "${var.public2_subnet_availability_zone}"
}

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.vpc.id}"
    # cidr_block = "10.1.2.0/24"
    cidr_block = "${var.private_subnet_cidr_block}"
    availability_zone = "${var.private_subnet_availability_zone}"
    map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "example" {
    vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route" "public" {
    route_table_id = "${aws_route_table.public.id}"
    gateway_id = "${aws_internet_gateway.example.id}"
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private" {
    route_table_id = "${aws_route_table.private.id}"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
    destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public1" {
    subnet_id = "${aws_subnet.public1.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public2" {
    subnet_id = "${aws_subnet.public2.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_eip" "nat_gateway" {
    vpc = true
    # depends_on = ["${aws_internet_gateway.example}"]
}

resource "aws_nat_gateway" "ngw" {
    allocation_id = "${aws_eip.nat_gateway.id}"
    subnet_id = "${aws_subnet.public1.id}"
    # depends_on = ["${aws_internet_gateway.example}"]
}
