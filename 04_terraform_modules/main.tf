terraform {
  backend "s3" {
    bucket = "test-udemy-12-11-2024"
    key    = "terraform_state/state"
    region = "eu-central-1"
  }
}

module "ec2" {
  source                        = "./modules/ec2"
  vpc_subnet_1a                 = module.vpc.subnet_1a_id
  vpc_subnet_1b                 = module.vpc.subnet_1b_id
  iam_instance_profile_ec2_main = module.iam.iam_instance_profile_ec2_main
}

module "ebs" {
  source      = "./modules/ebs"
  ec2_az_1_id = module.ec2.ec2_az_1_id
  ec2_az_2_id = module.ec2.ec2_az_2_id

}

module "iam" {
  source  = "./modules/iam"
  service = var.service
}

module "vpc" {
  source = "./modules/vpc"
}