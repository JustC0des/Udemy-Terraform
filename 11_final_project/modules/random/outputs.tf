output "random_secret" {
  value = random_password.password.result
  description = "Beschreibt ein zufällig generiertes Passwort"
  sensitive = true
}