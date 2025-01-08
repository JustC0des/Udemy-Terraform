terraform {
    backend "s3" {
        bucket = "test-udemy-12-11-2024"
        key = "terraform_state/state"
        region = "eu-central-1"
    }
}

module "vpc" {
  source = "./modules/vpc/"
}


resource "aws_instance" "new" {
  for_each = {
    "0" = "Eins"
    "1" = "Zwei"
  }
  ami           = "ami-0eddb4a4e7d846d6f"
  instance_type = "t3.micro"
  subnet_id = module.vpc.vpc_subnet_1a_id

  tags = {
    Name = "ExampleInstance${each.value}"
  }
}

resource "aws_ebs_volume" "my_ebs_volume" {
  count = 2
  availability_zone = "eu-central-1a" 
  size              = 10
  type       = "gp3"
  tags = {
    Name = "my_ebs_volume"
  }
}

resource "aws_volume_attachment" "my_volume-attachment" {
  count = 2
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.my_ebs_volume[count.index].id
  instance_id = aws_instance.new[count.index].id
}


