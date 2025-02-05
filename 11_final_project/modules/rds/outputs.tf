output "db_endpoint" {
    value = aws_db_instance.db.address
    description = "Beschreibt den Endpunkt für die RDS Datenbankinstanz"
}