resource "aws_vpc" "basic" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "az_1a" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.basic.id
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "az_1b" {
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.basic.id
  availability_zone = "eu-central-1b"
}

resource "aws_security_group" "ec2" {
  name        = "ec2"
  description = "Default Security group for Ec2 instance"
  vpc_id      = aws_vpc.basic.id

  tags = {
    Name = "sg-ec2"
  }
}

resource "aws_vpc_security_group_egress_rule" "example" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "10.0.0.0/8"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}
