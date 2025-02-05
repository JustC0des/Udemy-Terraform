resource "aws_secretsmanager_secret" "rds_secret" {
  name = "rds-password"
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = var.random_secret
  depends_on = [ aws_secretsmanager_secret.rds_secret ]
}

data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  depends_on = [ aws_secretsmanager_secret_version.rds_secret_version ]
}