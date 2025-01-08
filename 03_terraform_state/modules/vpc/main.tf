data "aws_vpc" "default" {
  id = "vpc-074bc5dca124fa9af"
}

data "aws_subnet" "eu-central-1a" {
  id = "subnet-09c61e2dc35eb0f1c"
}

resource "aws_security_group" "ec2" {
  name        = "ec2"
  description = "Default Security group for Ec2 instance"
  vpc_id      = data.aws_vpc.default.id

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

data "aws_instances" "new" {
  instance_state_names = ["running"]
#   depends_on = [ aws_instance.example ]
}
