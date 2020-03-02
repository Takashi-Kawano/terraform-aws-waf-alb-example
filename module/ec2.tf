resource "aws_instance" "ec2" {
    ami           = "${var.ec2_ami}"
    instance_type = "${var.ec2_instance_type}"
    vpc_security_group_ids = ["${aws_security_group.ec2_sg.id}"]

    subnet_id = "${aws_subnet.private.id}"

    tags = {
        Name = "${var.ec2_name}"
    }

    user_data = <<EOF
        #!/bin/bash
        yum install -y httpd
        systemctl start httpd.service
        systemctl enable httpd.service
        echo "Index.html for Health Check Test" > /var/www/html/index.html
EOF
}

resource "aws_security_group" "ec2_sg" {
    name = "${var.ec2_sg_name}"
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
