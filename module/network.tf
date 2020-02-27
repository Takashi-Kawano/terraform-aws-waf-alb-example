# variable "vpc_cidr_block" {}
# variable "public1_subnet_cidr_block" {}
# variable "public2_subnet_cidr_block" {}
# variable "private_subnet_cidr_block" {}
# variable "public1_subnet_availability_zone" {}
# variable "public2_subnet_availability_zone" {}
# variable "private_subnet_availability_zone" {}

# VPC作成
resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true
}

# パブリックサブネット1作成
resource "aws_subnet" "public1" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.1.0.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-1a"
}

# ALBがデフォルトでマルチAZのためパブリックサブネット2を追加(AZが1c)
resource "aws_subnet" "public2" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-southeast-1c"
}

# プライベートサブネット追加
resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "10.1.2.0/24"
    availability_zone = "ap-southeast-1a"
    map_public_ip_on_launch = false
}

# インターネットゲートウェイ作成
resource "aws_internet_gateway" "example" {
    vpc_id = "${aws_vpc.vpc.id}"
}

# ルートテーブル作成
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.vpc.id}"
}

# プライベートサブネット用のルートテーブル追加
resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.vpc.id}"
}

# ルーティング設定
# ルートテーブルとインターネットゲートウェイを関連付け
resource "aws_route" "public" {
    route_table_id = "${aws_route_table.public.id}"
    gateway_id = "${aws_internet_gateway.example.id}"
    destination_cidr_block = "0.0.0.0/0"
}

# プライベートサブネット用のルートテーブルとNATゲートウェイを紐付け
resource "aws_route" "private" {
    route_table_id = "${aws_route_table.private.id}"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
    destination_cidr_block = "0.0.0.0/0"
}

# ルートテーブルとパブリックサブネット1を関連付け
resource "aws_route_table_association" "public1" {
    subnet_id = "${aws_subnet.public1.id}"
    route_table_id = "${aws_route_table.public.id}"
}

# パブリックサブネット2にルートテーブル紐付け
resource "aws_route_table_association" "public2" {
    subnet_id = "${aws_subnet.public2.id}"
    route_table_id = "${aws_route_table.public.id}"
}

# プライベートサブネットとルートテーブルを関連付け
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
