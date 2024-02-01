resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(var.comman_tags,var.vpc_tags,
       {
        Name = local.name
       }
  )  
}
###### internet gateway ###
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.comman_tags,var.gw_tags,
   {
    Name = local.name
  }
  )
}
#### public subnets####
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(var.comman_tags,var.public_subnet_tags,
   {
    Name = "${local.name}-public-${local.az_names[count.index]}"
  }
  )
}
#### private subnets####
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(var.comman_tags,var.private_subnet_tags,
   {
    Name = "${local.name}-private-${local.az_names[count.index]}"
  }
  )
}
#### database subnets####
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(var.comman_tags,var.database_subnet_tags,
   {
    Name = "${local.name}-database-${local.az_names[count.index]}"
  }
  )
}
resource "aws_db_subnet_group" "default" {
  name       = "${local.name}"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${local.name}"
  }
}

####### public route table ##
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.comman_tags,var.public_route_table_tags,
  {
    Name = "${local.name}-public"
  }
  )
}
####### private route table ##
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.comman_tags,var.private_route_table_tags,
  {
    Name = "${local.name}-private"
  }
  )
}
####### public route table ##
resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.comman_tags,var.database_route_table_tags,
  {
    Name = "${local.name}-database"
  }
  )
}
### elastic ip for vpc ###
resource "aws_eip" "eip" {
  domain   = "vpc"
}
###### natgateway ###
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.comman_tags,var.aws_nat_gateway_tags,
  {
    Name = local.name
  }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}
##### adding  public routes ####

resource "aws_route" "public_routes" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}
resource "aws_route" "private_routes" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}
resource "aws_route" "database_routes" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}
#### route table assosication  with subnets ###
resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database_route_table.id
}
