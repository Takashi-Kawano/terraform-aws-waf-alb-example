
variable "allow_request_ip" {}

# WAFリージョナルで使用するIPセット
resource "aws_wafregional_ipset" "ipset" {
  name = "tfIPSet"

  ip_set_descriptor {
    type  = "IPV4"
    value = "${var.allow_request_ip}" # 接続元のグローバルIPに変更してください
  }
  # https://manip.tools.isca.jp/ip_address/
}

# WAFリージョナルで使用するルール
resource "aws_wafregional_rule" "waf_rule" {
  name        = "tfWAFRule"
  metric_name = "tfWAFRule"

  predicate {
    data_id = "${aws_wafregional_ipset.ipset.id}"
    negated = false
    type    = "IPMatch"
  }
}

# WAFリージョナルで使用するアクセスコントロールリスト
resource "aws_wafregional_web_acl" "web_acl" {
  name        = "acl"
  metric_name = "acl"

  default_action {
    type = "BLOCK"
  }

# Ruleを追加しない状態でまずつくたほうがいいかな
  rule {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = "${aws_wafregional_rule.waf_rule.id}"
  }
}

# ALBとアクセスコントロールリストを関連付け
resource "aws_wafregional_web_acl_association" "waf_acl_association" {
  resource_arn = "${aws_alb.alb.arn}"
  web_acl_id   = "${aws_wafregional_web_acl.web_acl.id}"
}

