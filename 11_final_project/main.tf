module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source       = "./modules/ec2"
  vpc_id       = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnets
  public_subnet_ids = module.vpc.public_subnets
  instance_type = "t3.micro"
  ec2_security_group = module.vpc.ec2_security_group
  elb_security_group = module.vpc.elb_security_group
  rds_identifier =module.rds.db_endpoint
  postgres_username = local.postgres_username
  postgres_password = module.secretsmanager.rds_password
  depends_on = [ module.rds ]
}

module "rds" {
  source       = "./modules/rds"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
  postgres_username  = local.postgres_username
  postgres_password  = module.secretsmanager.rds_password
  rds_security_group = module.vpc.rds_security_group
  depends_on = [ module.secretsmanager ]
}

module "random" {
  source = "./modules/random"
}

module "secretsmanager" {
  source = "./modules/secretsmanager"
  random_secret = module.random.random_secret
}