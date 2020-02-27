# variable "alb_name" {}
# variable "alb_tg_name" {}
# variable "alb_sg_name" {}

# ALB作成
resource "aws_alb" "alb" {
  name     = "alb"
  internal = false
  subnets  = ["${aws_subnet.public1.id}", "${aws_subnet.public2.id}"]
  security_groups = ["${aws_security_group.alb.id}"]
}

# ALBリスナー作成
resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
  }
}

# ALBターゲットグループ作成
resource "aws_lb_target_group" "target_group" {
    name = "alb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = "${aws_vpc.vpc.id}"
    health_check {
        interval = 15
        healthy_threshold = 3
        timeout = 10
    }
}

# ターゲットグループとEC2インスタンスを紐付け
resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    target_id        = "${aws_instance.ec2.id}"
    port             = 80
}

# ALB用のセキュリティーグループ作成
resource "aws_security_group" "alb" {
    name = "kawano-alb-sg"
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

