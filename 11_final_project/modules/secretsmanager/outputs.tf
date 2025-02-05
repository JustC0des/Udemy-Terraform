output "rds_password" {
  value = data.aws_secretsmanager_secret_version.db_password.secret_string
  description = "Beschreibt das Passwort, das im SecretsManager gespeichert wurde"
  sensitive = true
}