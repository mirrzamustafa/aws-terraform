// default vpc
data "aws_vpc" "default_vpc" {
  default = true
}

// default subnet ids
data "aws_subnet_ids" "default_subnets" {
  vpc_id = data.aws_vpc.default_vpc.id
}

// security group for compute
resource "aws_security_group" "instances" {
  name = "mirza-ec2-sg-${terraform.workspace}"
}

// security group for compute - http inbound traffic
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instances.id
}

// security group for compute - ssh inbound traffic
resource "aws_security_group_rule" "allow_ssh_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instances.id
}

// security group for compute - outbound traffic
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.instances.id
}

// security groups for alb
resource "aws_security_group" "alb_sg" {
  name = "mirza-alb-sg-${terraform.workspace}"
}

// inbound security group for alb
resource "aws_security_group_rule" "allow_alb_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

// outbound security group for alb
resource "aws_security_group_rule" "allow_alb_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

// create a aws key pair
resource "aws_key_pair" "tf_key_pair" {
  key_name   = "tf-key-pair-${terraform.workspace}"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair-${terraform.workspace}"
}
