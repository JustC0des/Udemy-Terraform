data "aws_secretsmanager_secret_version" "secret-version" {
  secret_id = "arn:aws:secretsmanager:eu-central-1:904233110947:secret:rds_test_pwd-Uv8kgF"
}

output "rds_passwort" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["rds_passwort"]
  sensitive = true
}

output "rds_user" {
  value = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["username"]
}