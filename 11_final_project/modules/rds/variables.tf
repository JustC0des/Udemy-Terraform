variable "postgres_username" {
    type = string
    description = "Beschreibt den Nutzername, der in der Datenbank als Admin genutzt wird"
}

variable "postgres_password" {
    type = string
    description = "Beschreibt das Passwort, das in der Datenbank für dem Admin genutzt wird"
    sensitive = true
}

variable "vpc_id" {
    type = string
    description = "Beschreibt die ID des VPC's"
}

variable "subnet_ids" {
  type = list(string)
  description = "Beschreibt die IDs der Subnetze"
}

variable "rds_security_group" {
  type = string
  description = "Beschreibt die ID der Security-Gruppe für RDS"
}