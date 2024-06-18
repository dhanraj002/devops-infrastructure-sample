variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Name of the environment e.g. production/Dev"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(any)
  default = {
    "Project" : "cloudtech"
  }
}

variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
}

# Declare AZ data source to ensure the region zones are always used
data "aws_availability_zones" "available" {
  state = "available"
}

variable "az_count" {
  type = number
}

# VPC CIDR - should be from the RFC1918 ranges
variable "vpc_cidr_ip" {
  type = string
}

variable "enable_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  default     = true
}

variable "enable_dns" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default     = true
}

# Create one NAT gateway for all private networks
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}
