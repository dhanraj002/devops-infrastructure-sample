
# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_hostnames
  enable_dns_support   = var.enable_dns

  tags = merge(
    var.tags,
    { Name = "${var.name}-vpc" }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# DHCP Options Set

resource "aws_vpc_dhcp_options" "this" {
  count = var.enable_dhcp_options ? 1 : 0

  domain_name         = var.dhcp_options_domain_name != "" ? var.dhcp_options_domain_name : "${var.region}.compute.internal"
  domain_name_servers = var.dhcp_options_domain_name_servers

  tags = merge(
    var.tags,
    { "Name" = "${var.name}-${var.dhcp_options_suffix}" }
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.enable_dhcp_options ? 1 : 0

  vpc_id          = aws_vpc.this.id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

# Internet Gateway

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

 tags = merge(
    var.tags,
    {  Name = "${var.name}-igw" }
  )
}


################### NAT Gateway ######################

resource "aws_eip" "nat_eip" {
  count = length(var.azs)
  vpc   = true
  tags = merge(
    var.tags,
    {
      "Name" = format(
        "${var.name}-eip-${var.nat_gateway_suffix}-%s",
        substr(element(var.azs, count.index), -1, -1),
      )
    }
  )
}

resource "aws_nat_gateway" "this" {
  count         = length(var.azs)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  depends_on    = [aws_internet_gateway.this]

  tags = merge(
    var.tags,
    {
      "Name" = format(
        "${var.name}-${var.nat_gateway_suffix}-%s",
        substr(element(var.azs, count.index), -1, -1),
      )
    }
  )
}

resource "aws_route" "private_nat_gateway" {
  count = length(var.azs)

  route_table_id         = element(aws_route_table.private_rt[*].id, count.index)
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "6m"
  }
}

# Public subnet


resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.tags,
    {
      "Name" = format(
        "${var.name}-subnet-${var.public_subnet_tier}-${var.public_subnet_suffix}-%s",
        substr(element(var.azs, count.index), -1, -1),
      )
    }
  )

  map_public_ip_on_launch = var.map_public_ip_on_launch
}
resource "aws_subnet" "public_elb_subnets" {
  count             = length(var.public_elb_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_elb_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(
    var.tags,
    {
      "Name" = format(
        "${var.name}-subnet-${var.public_elb_subnet_tier}-${var.public_subnet_suffix}-%s",
        substr(element(var.azs, count.index), -1, -1),
      ),
    }
  )

  map_public_ip_on_launch = var.map_public_ip_on_launch
}

# Private subnet


resource "aws_subnet" "private_app_subnets" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_app_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  count             = length(var.private_app_subnets)

  tags = merge(
    var.tags,
    {
      "Name" = format(
        "${var.name}-subnet-${var.private_app_subnet_tier}-${var.private_subnet_suffix}-%s",
        substr(element(var.azs, count.index), -1, -1),
      ),
    },
  )
}

resource "aws_subnet" "private_elb_subnets" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_elb_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  count             = length(var.private_elb_subnets)

  tags = merge(
    var.tags,
    {
      "Name" = format(
        "${var.name}-subnet-${var.private_elb_subnet_tier}-${var.private_subnet_suffix}-%s",
        substr(element(var.azs, count.index), -1, -1),
      ),
    },
  )
}

resource "aws_subnet" "private_db_subnets" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_db_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  count             = length(var.private_db_subnets)

  tags = merge(
    var.tags,
    {
      "Name" = format(
        "${var.name}-subnet-${var.private_db_subnet_tier}-${var.private_subnet_suffix}-%s",
        substr(element(var.azs, count.index), -1, -1),
      ),
    },
  )
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.this.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { "Name" = "${var.name}-default-security-group" }
  )
}

################################################################################
# Publiс routes
################################################################################

resource "aws_route_table" "public_rt" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    { "Name" = "${var.name}-${var.public_subnet_suffix}-rt" }
  )
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

################################################################################
# Public Route table association
################################################################################

resource "aws_route_table_association" "Public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt[0].id
}

resource "aws_route_table_association" "Public_elb" {
  count = length(var.public_elb_subnets)

  subnet_id      = element(aws_subnet.public_elb_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_rt[0].id
}

################################################################################
# Private routes
# There are as many routing tables as the number of NAT gateways
################################################################################

resource "aws_route_table" "private_rt" {
  count = length(var.azs)

  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      "Name" = var.single_nat_gateway ? "${var.name}-${var.private_subnet_suffix}-rt" : format(
        "${var.name}-${var.private_subnet_suffix}-rt-%s",
        substr(element(var.azs, count.index), -1, -1),
      )
    },
  )
}

################################################################################
# Route table association
################################################################################

resource "aws_route_table_association" "private" {
  count = length(var.azs)

  subnet_id      = element(aws_subnet.private_app_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_rt[count.index].id
}


resource "aws_route_table_association" "elb_subnet" {
  count = length(var.azs)

  subnet_id      = element(aws_subnet.private_elb_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_rt[count.index].id
}

resource "aws_route_table_association" "db_subnet" {
  count = length(var.azs)

  subnet_id      = element(aws_subnet.private_db_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_rt[count.index].id
}
