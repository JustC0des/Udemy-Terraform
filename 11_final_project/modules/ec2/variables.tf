variable "vpc_id" {
    type = string
    description = "Beschreibt die ID des VPC's"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "Beschreibt die IDs der privaten Subnetze"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "Beschreibt die IDs der öffentlichen Subnetze"
}

variable "instance_type" {
    type = string
    description = "Beschreibt den Typ der Instanz, der für die EC2 genutzt wird"
}

variable "ec2_security_group" {
  type = string
  description = "Beschreibt die ID der Security-Gruppe für EC2"
}

variable "elb_security_group" {
  type = string
  description = "Beschreibt die ID der Security-Gruppe für ELB"
}

variable "postgres_username" {
    type = string
    description = "Beschreibt den Nutzername, der in der Datenbank als Admin genutzt wird"
}

variable "postgres_password" {
    type = string
    description = "Beschreibt das Passwort, das in der Datenbank für dem Admin genutzt wird"
    sensitive = true
}

variable "rds_identifier" {
    type = string
    description = "Beschreibt den Identifier unter dem die RDS Datenbank erreichbar ist"
}