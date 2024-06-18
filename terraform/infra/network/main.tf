locals {
  naming_prefix = "${var.project_name}-${var.environment}"
  az_list       = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

locals {
  public_subnets = var.az_count != 2 ? [
    cidrsubnet(var.vpc_cidr_ip, 9, 0),
    cidrsubnet(var.vpc_cidr_ip, 9, 1),
    cidrsubnet(var.vpc_cidr_ip, 9, 2),
    ] : [
    cidrsubnet(var.vpc_cidr_ip, 9, 0),
    cidrsubnet(var.vpc_cidr_ip, 9, 1),

  ]
  public_elb_subnets = var.az_count != 2 ? [
    cidrsubnet(var.vpc_cidr_ip, 9, 4),
    cidrsubnet(var.vpc_cidr_ip, 9, 5),
    cidrsubnet(var.vpc_cidr_ip, 9, 6),
    ] : [
    cidrsubnet(var.vpc_cidr_ip, 9, 2),
    cidrsubnet(var.vpc_cidr_ip, 9, 3),

  ]
  private_app_subnets = var.az_count != 2 ? [
    cidrsubnet(var.vpc_cidr_ip, 9, 8),
    cidrsubnet(var.vpc_cidr_ip, 9, 9),
    cidrsubnet(var.vpc_cidr_ip, 9, 10),
    ] : [
    cidrsubnet(var.vpc_cidr_ip, 9, 6),
    cidrsubnet(var.vpc_cidr_ip, 9, 7),
  ]
  private_elb_subnets = var.az_count != 2 ? [
    cidrsubnet(var.vpc_cidr_ip, 9, 12),
    cidrsubnet(var.vpc_cidr_ip, 9, 13),
    cidrsubnet(var.vpc_cidr_ip, 9, 14),
    ] : [
    cidrsubnet(var.vpc_cidr_ip, 9, 4),
    cidrsubnet(var.vpc_cidr_ip, 9, 5),

  ]
  private_db_subnets = var.az_count != 2 ? [
    cidrsubnet(var.vpc_cidr_ip, 6, 16),
    cidrsubnet(var.vpc_cidr_ip, 6, 17),
    cidrsubnet(var.vpc_cidr_ip, 6, 18),
    ] : [
    cidrsubnet(var.vpc_cidr_ip, 9, 8),
    cidrsubnet(var.vpc_cidr_ip, 9, 9),
  ]
}

module "vpc" {
  source = "../../modules/vpc" 
  name = local.naming_prefix
  cidr = var.vpc_cidr_ip
  azs = local.az_list
  region = var.aws_region

  # Nat gateway configuration
  single_nat_gateway = var.single_nat_gateway

  public_subnets      = local.public_subnets
  public_elb_subnets  = local.public_elb_subnets
  private_app_subnets = local.private_app_subnets
  private_elb_subnets = local.private_elb_subnets
  private_db_subnets  = local.private_db_subnets

  # DNS support
  enable_hostnames = var.enable_hostnames
  enable_dns       = var.enable_dns
}
