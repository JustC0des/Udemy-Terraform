resource "aws_ebs_volume" "ec2_az_1" {
  availability_zone = "eu-central-1a"
  size              = 10
  type              = "gp3"
  tags = {
    Name = "my_ebs_volume"
  }
}

resource "aws_ebs_volume" "ec2_az_2" {
  availability_zone = "eu-central-1b"
  size              = 10
  type              = "gp3"
  tags = {
    Name = "my_ebs_volume"
  }
}

resource "aws_volume_attachment" "ec2_az_1" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.ec2_az_1.id
  instance_id = var.ec2_az_1_id
}

resource "aws_volume_attachment" "ec2_az_2" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.ec2_az_2.id
  instance_id = var.ec2_az_2_id
}
