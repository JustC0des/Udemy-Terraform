resource "aws_db_instance" "postgres" {
    instance_class = "db.t3.micro"
    engine         = "postgres"
    engine_version = "17.2"
    username        = var.rds_user
    password        = var.rds_passwort
    allocated_storage = 10
    skip_final_snapshot = true
  
}