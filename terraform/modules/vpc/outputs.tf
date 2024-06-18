output "vpc_id" {
  description = "The unique identifier (ID) of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of unique identifiers (IDs) for public subnets."
  value       = aws_subnet.public_subnets[*].id
}

output "public_elb_subnet_ids" {
  description = "List of unique identifiers (IDs) for public ELB subnets."
  value       = aws_subnet.public_elb_subnets[*].id
}

output "private_app_subnet_ids" {
  description = "List of unique identifiers (IDs) for private application subnets."
  value       = aws_subnet.private_app_subnets[*].id
}

output "private_elb_subnet_ids" {
  description = "List of unique identifiers (IDs) for private ELB subnets."
  value       = aws_subnet.private_elb_subnets[*].id
}

output "private_db_subnet_ids" {
  description = "List of unique identifiers (IDs) for private database subnets."
  value       = aws_subnet.private_db_subnets[*].id
}

output "internet_gateway_id" {
  description = "The unique identifier (ID) of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_ids" {
  description = "List of unique identifiers (IDs) for NAT Gateways."
  value       = aws_nat_gateway.this[*].id
}

output "default_security_group_id" {
  description = "The unique identifier (ID) of the default security group."
  value       = aws_default_security_group.default.id
}

output "public_route_table_id" {
  description = "The unique identifier (ID) of the public route table."
  value       = aws_route_table.public_rt[0].id
}

output "private_route_table_ids" {
  description = "List of unique identifiers (IDs) for private route tables."
  value       = aws_route_table.private_rt[*].id
}
