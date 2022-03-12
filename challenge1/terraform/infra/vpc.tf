resource "aws_vpc" "vpc_assessment" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "code-assessment-vpc"
    Owner       = "code-assessment"
    Environment = "assessment"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc_assessment.id
  map_public_ip_on_launch = "true"
  availability_zone       = element(var.az_list, count.index)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  count                   = length(var.az_list)
  tags = {
    Name        = "subnet-pub-assessment-${count.index}"
    Owner       = "code-assessment"
    Environment = "assessment"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc_assessment.id
  availability_zone = element(var.az_list, count.index)
  cidr_block        = element(var.private_subnets_cidr, count.index)
  count             = length(var.az_list)
  tags = {
    Name        = "subnet-priv-cc"
    Owner       = "code-assessment"
    Environment = "assessment"
  }
}

resource "aws_internet_gateway" "code-assessment-igw" {
  vpc_id = aws_vpc.vpc_assessment.id

  tags = {
    Name        = "code-assessment-igw"
    Owner       = "code-assessment"
    Environment = "assessment"
  }
}

resource "aws_route_table" "code_assessment_route" {
  vpc_id = aws_vpc.vpc_assessment.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.code-assessment-igw.id
  }

  tags = {
    Name        = "code-assessment-route-table"
    Owner       = "code-assessment"
    Environment = "assessment"
  }
}

resource "aws_route_table_association" "code_assessment_rta1" {
  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.code_assessment_route.id
}

resource "aws_route_table_association" "code_assessment_rta2" {
  subnet_id      = aws_subnet.public[1].id
  route_table_id = aws_route_table.code_assessment_route.id
}



