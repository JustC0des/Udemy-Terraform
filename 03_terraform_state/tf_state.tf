terraform {
  backend "s3" {
    bucket = "test-udemy-12-11-2024"
    key    = "terraform_state/state"
    region = "eu-central-1"
  }
}

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

resource "aws_instance" "example" {
  ami           = "ami-0eddb4a4e7d846d6f"
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.eu-central-1a.id

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_ebs_volume" "my_ebs_volume" {
  availability_zone = "eu-central-1a"
  size              = 10
  type              = "gp3"
  tags = {
    Name = "my_ebs_volume"
  }
}

resource "aws_volume_attachment" "my_volume_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.my_ebs_volume.id
  instance_id = aws_instance.example.id
}