output "subnet_1a_id" {
  value       = aws_subnet.az_1a.id
  description = "Beschreibt die ID des Subnetzes in der AZ 1A in Frankfurt"
}

output "subnet_1b_id" {
  value       = aws_subnet.az_1b.id
  description = "Beschreibt die ID des Subnetzes in der AZ 1B in Frankfurt"
}