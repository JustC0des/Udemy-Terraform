output "iam_instance_profile_ec2_main" {
  value       = aws_iam_instance_profile.example.name
  description = "Beschreibt den namen des Standard Instanz Profils für die EC2 Instanzen"
}