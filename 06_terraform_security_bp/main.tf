module "iam" {
  source = "./modules/iam"
}

module "rds" {
  source       = "./modules/rds"
  rds_passwort = module.secretsmanager.rds_passwort
  rds_user     = module.secretsmanager.rds_user
}

module "secretsmanager" {
  source = "./modules/secretsmanager"
}

terraform {
  backend "s3" {
    bucket         = "test-udemy-12-11-2024"
    key            = "terraform_state/state_locked"
    region         = "eu-central-1"
    dynamodb_table = "terraform_lock"
    encrypt        = true
  }
}