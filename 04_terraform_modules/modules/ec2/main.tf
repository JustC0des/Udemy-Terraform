data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_instance" "az_1" {
  ami                  = "ami-0eddb4a4e7d846d6f"
  instance_type        = "t3.micro"
  subnet_id            = var.vpc_subnet_1a
  key_name             = aws_key_pair.my_key.id
  iam_instance_profile = var.iam_instance_profile_ec2_main

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_instance" "az_2" {
  ami                  = "ami-0eddb4a4e7d846d6f"
  instance_type        = "t3.micro"
  subnet_id            = var.vpc_subnet_1b
  key_name             = aws_key_pair.my_key.id
  iam_instance_profile = var.iam_instance_profile_ec2_main

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_key_pair" "my_key" {
  key_name   = "ec2_login_key"
  public_key = file("keys/id_rsa.pub")
}