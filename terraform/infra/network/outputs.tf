# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_app_subnets" {
  description = "App Subnets"
  value       = module.vpc.private_app_subnet_ids
}

output "private_elb_subnets" {
  description = "ELB private subnets"
  value       = module.vpc.private_elb_subnet_ids
}

output "default_sg_id" {
  description = "Default security group Id"
  value       = module.vpc.default_security_group_id
}
