resource "aws_db_subnet_group" "rds" {
  name = "rds"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "Meine DB Subnetzgruppe"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  username           = var.postgres_username
  password           = var.postgres_password
  publicly_accessible = false
  db_name            = "ecommerce"
  identifier = "ec2-instance-e-commerce"
  skip_final_snapshot = true
  vpc_security_group_ids = [ var.rds_security_group ]
  db_subnet_group_name = aws_db_subnet_group.rds.name
}