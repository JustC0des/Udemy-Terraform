resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count      = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  availability_zone = count.index == 1 ? "eu-central-1a" : "eu-central-1b"
  tags = {
    Name = "sn-public-${count.index}"
  }
}

resource "aws_route" "public_subnet" {
    route_table_id = aws_vpc.main.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
    
}

resource "aws_subnet" "private" {
  count      = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.${count.index + 2}.0/24"
  availability_zone = count.index == 1 ? "eu-central-1a" : "eu-central-1b"
  tags = {
    Name = "sn-private-${count.index}"
  }
}

resource "aws_security_group" "rds" {
    name        = "rds"
    vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "ec2" {
    name        = "ec2"
    vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "elb" {
    name        = "elb"
    vpc_id = aws_vpc.main.id
}


resource "aws_vpc_security_group_ingress_rule" "rds_ec2_access" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4 = aws_vpc.main.cidr_block
  ip_protocol = -1
}


resource "aws_vpc_security_group_egress_rule" "ec2_egress" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ec2" {
  security_group_id = aws_security_group.ec2.id
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  description = "Erlaubt SSH Verbindungen auf die EC2 Instanz"
}

resource "aws_vpc_security_group_ingress_rule" "elb_ec2" {
  security_group_id = aws_security_group.ec2.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  description = "Erlaubt dem Loadbalancer auf die EC2 Instanzen zuzugreifen"
}

resource "aws_vpc_security_group_ingress_rule" "public_elb" {
  security_group_id = aws_security_group.elb.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  description = "Erlaubt von public auf den ELB zuzugreifen"
}

resource "aws_vpc_security_group_egress_rule" "elb_ec2" {
  security_group_id = aws_security_group.elb.id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
  description = "Erlaubt dem Loadbalancer auf die EC2 Instanzen zuzugreifen"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "EC2_main"
  }
}
