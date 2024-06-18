variable "name" {
  description = "Identifier name for all resources within the VPC."
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC, e.g., '10.0.0.0/16'."
}

variable "enable_hostnames" {
  description = "Enable or disable DNS hostnames in the VPC (true or false)."
  default     = true
}

variable "enable_dns" {
  description = "Enable or disable DNS support in the VPC (true or false)."
  default     = true
}

variable "tags" {
  description = "Key-value map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "azs" {
  description = "List of availability zones (AZs) to be used within the region."
  type        = list(string)
}


variable "nat_gateway_suffix" {
  description = "Suffix to append to NAT gateway names."
  type        = string
  default     = "ngw"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets within the VPC."
  type        = list(string)
  default     = []
}


variable "public_subnet_tier" {
  description = "Tier classification for public subnets (e.g., 'ifs'(internet facing subnet)."
  type        = string
  default     = "ifs"
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnet names."
  type        = string
  default     = "public"
}

variable "public_elb_subnets" {
  description = "List of CIDR blocks for public ELB subnets within the VPC."
  type        = list(string)
  default     = []
}

variable "public_elb_subnet_tier" {
  description = "Tier classification for public ELB subnets (e.g., 'elb')."
  type        = string
  default     = "elb"
}

variable "private_app_subnets" {
  description = "List of CIDR blocks for private application subnets within the VPC."
  type        = list(string)
  default     = []
}

variable "private_app_subnet_tier" {
  description = "Tier classification for private application subnets (e.g., 'app')."
  type        = string
  default     = "app"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnet names."
  type        = string
  default     = "private"
}

variable "private_elb_subnets" {
  description = "List of CIDR blocks for private ELB subnets within the VPC."
  type        = list(string)
  default     = []
}

variable "private_elb_subnet_tier" {
  description = "Tier classification for private ELB subnets (e.g., 'elb')."
  type        = string
  default     = "elb"
}

variable "private_db_subnets" {
  description = "List of CIDR blocks for private database subnets within the VPC."
  type        = list(string)
  default     = []
}

variable "private_db_subnet_tier" {
  description = "Tier classification for private database subnets (e.g., 'db')."
  type        = string
  default     = "db"
}

variable "default_security_group_tags" {
  description = "Additional tags for the default security group."
  type        = map(string)
  default     = {}
}

variable "default_security_group_name" {
  description = "Name to assign to the default security group."
  type        = string
  default     = null
}

variable "single_nat_gateway" {
  description = "Provision a single NAT gateway for all private subnets (true or false)."
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "Automatically assign public IPs to instances launched in the public subnet (true or false)."
  default     = true
}

variable "enable_dhcp_options" {
  description = "Enable custom DHCP options for the VPC (true or false)."
  type        = bool
  default     = true
}

variable "dhcp_options_domain_name" {
  description = "Domain name for the DHCP options set (requires enable_dhcp_options to be true)."
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "List of DNS server addresses for DHCP options set (default is 'AmazonProvidedDNS'). Requires enable_dhcp_options to be true."
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_suffix" {
  description = "Suffix to append to DHCP options set names."
  type        = string
  default     = "dhcpoptions"
}

variable "nat_gateway_destination_cidr_block" {
  description = "Custom destination route for the NAT gateway (default is '0.0.0.0/0')."
  type        = string
  default     = "0.0.0.0/0"
}

variable "region" {
  description = "AWS region"
  type        = string
}
