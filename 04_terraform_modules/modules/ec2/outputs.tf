output "ec2_az_1_id" {
  value       = aws_instance.az_1.id
  description = "Beschreibt die ID der EC2 instanz in der AZ 1 in Frankfurt"
}

output "ec2_az_2_id" {
  value       = aws_instance.az_2.id
  description = "Beschreibt die ID der EC2 instanz in der AZ 2 in Frankfurt"
}