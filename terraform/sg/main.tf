resource "aws_security_group" "employee_data_sg" {
  name   = var.name
  vpc_id = "vpc-05b050daa09deb4d0" # var.vpc_id
  tags   = var.tags
  lifecycle {
    create_before_destroy = true
  }
  revoke_rules_on_delete = true
}

resource "aws_security_group_rule" "sg_inbound_rule_1" {
  from_port         = 0
  protocol          = "All"
  security_group_id = aws_security_group.employee_data_sg.id
  to_port           = 65535
  type              = "ingress"  
  cidr_blocks       = ["10.0.0.0/8"] #var.ingresscidr
}

# all outbound access
resource "aws_security_group_rule" "sg_outbound_access" {
  from_port         = 0
  protocol          = "All"
  security_group_id = aws_security_group.employee_data_sg.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"] #var.egress
}