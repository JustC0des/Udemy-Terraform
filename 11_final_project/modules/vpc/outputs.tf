output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = [aws_subnet.private[0].id, aws_subnet.private[1].id]
}

# beide Ausgaben erfüllen den gleichen Zweck

output "vpc_id" {
    value = aws_vpc.main.id
    description = "Beschreibt die ID des VPC's"
}

output "ec2_security_group" {
  value = aws_security_group.ec2.id
  description = "Beschreibt die ID der Security-Gruppe für EC2"
}

output "elb_security_group" {
  value = aws_security_group.elb.id
  description = "Beschreibt die ID der Security-Gruppe für EC2"
}

output "rds_security_group" {
  value = aws_security_group.rds.id
  description = "Beschreibt die ID der Security-Gruppe für RDS"
}