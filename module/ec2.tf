# variable "ec2_name" {}
# variable "ec2_ami" {}
# variable "ec2_instance_type" {}
# variable "ec2_sg_name" {}

# インスタンス作成
resource "aws_instance" "ec2" {
    ami           = "ami-0f02b24005e4aec36"
    instance_type = "t3.micro"
    vpc_security_group_ids = ["${aws_security_group.example_ec2.id}"]

    # subnet_id = "${aws_subnet.public1.id}"
    subnet_id = "${aws_subnet.private.id}"

    tags = {
        Name = "kawano"
    }

    user_data = <<EOF
        #!/bin/bash
        yum install -y httpd
        systemctl start httpd.service
        systemctl enable httpd.service
        echo "Index.html for Health Check Test" > /var/www/html/index.html
EOF
}

# セキュリティーグループ作成
resource "aws_security_group" "example_ec2" {
    name = "kawano-ec2-sg"
    vpc_id = "${aws_vpc.vpc.id}"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
