output "vpc_id" {
  value = module.vpc.vpc_id
}

# output "ec2_public_ip" {
#   value = module.ec2.ec2_public_ip
# }

output "rds_endpoint" {
  value = module.rds.db_endpoint
}