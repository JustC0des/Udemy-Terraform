variable "vpc_subnet_1a" {
  description = "Beschreibt die ID des Subnetzes in der AZ 1A in Frankfurt"
  type        = string
}

variable "vpc_subnet_1b" {
  description = "Beschreibt die ID des Subnetzes in der AZ 1B in Frankfurt"
  type        = string
}

variable "iam_instance_profile_ec2_main" {
  description = "Beschreibt den namen des Standard Instanz Profils für die EC2 Instanzen"
  type        = string
}