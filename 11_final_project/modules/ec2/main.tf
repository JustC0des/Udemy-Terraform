# data "local_file" "user_data" {
#     filename = "${path.module}/user_data.sh"
    
# }

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")
  vars = {
    postgres_username = var.postgres_username
    postgres_password = var.postgres_password
    rds_identifier = var.rds_identifier
  }
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = [ "amazon" ]

    filter {
      name = "name"
      values = [ "al2023-ami-2023*" ]
    }

    filter {
      name = "architecture"
      values = [ "x86_64" ]
    }

    filter {
      name = "root-device-type"
      values = [ "ebs" ]
    }

    filter {
      name = "virtualization-type"
      values = [ "hvm" ]
    }
}

# resource "aws_instance" "web" {
#   ami           = data.aws_ami.amazon_linux.id
#   instance_type = var.instance_type
#   subnet_id     = var.subnet_ids[0]
#   user_data = data.local_file.user_data.content
#   user_data_replace_on_change = true
#   associate_public_ip_address = true
#   vpc_security_group_ids = [ var.ec2_security_group ]
#   depends_on = [
#     data.local_file.user_data
#   ]
#   tags = {
#     Name = "ec2_instance_e_commerce"
#   }
# }



resource "aws_lb" "web" {
  name               = "web-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.elb_security_group]
  subnets           = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "web-load-balancer"
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval           = 30
    timeout            = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_launch_template" "web" {
  name_prefix   = "web-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  user_data     = base64encode(data.template_file.user_data.rendered)

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.ec2_security_group]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ec2_instance_e_commerce"
    }
  }
}


resource "aws_autoscaling_group" "web" {
  desired_capacity     = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ec2_instance_e_commerce"
    propagate_at_launch = true
  }
}