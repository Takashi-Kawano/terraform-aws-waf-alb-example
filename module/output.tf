output "dns_name" {
    description = "The DNS name of the alb."
    value = "${aws_alb.alb.dns_name}"
}
