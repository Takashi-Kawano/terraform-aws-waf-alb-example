resource "aws_wafregional_ipset" "ipset" {
  name = "tfIPSet"

  ip_set_descriptor {
    type  = "IPV4"
    value = "${var.allow_ip}"
  }
}

resource "aws_wafregional_rule" "waf_rule" {
  name        = "tfWAFRule"
  metric_name = "tfWAFRule"

  predicate {
    data_id = "${aws_wafregional_ipset.ipset.id}"
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_wafregional_web_acl" "web_acl" {
  name        = "acl"
  metric_name = "acl"

  default_action {
    type = "BLOCK"
  }

  rule {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = "${aws_wafregional_rule.waf_rule.id}"
  }
}

resource "aws_wafregional_web_acl_association" "waf_acl_association" {
  resource_arn = "${aws_alb.alb.arn}"
  web_acl_id   = "${aws_wafregional_web_acl.web_acl.id}"
}
