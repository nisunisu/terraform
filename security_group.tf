# For RDS
resource "aws_security_group" "rds" {
  name        = "securitygroup_rds_terraform_${terraform.workspace}"
  description = "Allow MYSQL/Aurora"
  vpc_id      = aws_vpc.default.id
  tags = {
    Name = "securitygroup_rds_terraform_${terraform.workspace}"
  }
}
## Security Group Rule
resource "aws_security_group_rule" "Inbound_database" {
  security_group_id = aws_security_group.rds.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks = [
    "${aws_instance.web_1.private_ip}/32"
  ]
}
resource "aws_security_group_rule" "Outbound_allow_all" {
  security_group_id = aws_security_group.rds.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

# For ALB
resource "aws_security_group" "alb" {
  name        = "securitygroup_alb_terraform_${terraform.workspace}"
  description = "Allow http"
  vpc_id      = aws_vpc.default.id
  tags = {
    Name = "securitygroup_alb_terraform_${terraform.workspace}"
  }
}
## Security Group Rule
resource "aws_security_group_rule" "Inbound_http" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}
resource "aws_security_group_rule" "Outbound_http" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.ec2.id
}

# For EC2
resource "aws_security_group" "ec2" {
  name        = "securitygroup_ec2_terraform_${terraform.workspace}"
  description = "Allow ssh and http"
  vpc_id      = aws_vpc.default.id
  tags = {
    Name = "securitygroup_ec2_terraform_${terraform.workspace}"
  }
}
## Security Group Rule
resource "aws_security_group_rule" "Inbound_ssh" {
  security_group_id = aws_security_group.ec2.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = [
    "${var.my_home_ip}/32"
  ]
}
resource "aws_security_group_rule" "Inbound_alb_http" {
  security_group_id = aws_security_group.ec2.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = aws_security_group.alb.id
}
resource "aws_security_group_rule" "Outbound_allow_all_ssh" {
  security_group_id = aws_security_group.ec2.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}