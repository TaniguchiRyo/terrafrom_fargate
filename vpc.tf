## vpc
resource "aws_vpc" "vpc_main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.project-name}-vpc"
  }
}

## subnet
resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.vpc_subnet["public-a"]
  map_public_ip_on_launch = "1"
  availability_zone       = var.availability_zone["a"]

  tags = {
    Name = "${var.project-name}-public-a"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.vpc_subnet["public-c"]
  map_public_ip_on_launch = "1"
  availability_zone       = var.availability_zone["c"]

  tags = {
    Name = "${var.project-name}-public-c"
  }
}

resource "aws_subnet" "private-a" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.vpc_subnet["private-a"]
  map_public_ip_on_launch = "0"
  availability_zone       = var.availability_zone["a"]

  tags = {
    Name = "${var.project-name}-private-a"
  }
}

resource "aws_subnet" "private-c" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.vpc_subnet["private-c"]
  map_public_ip_on_launch = "0"
  availability_zone       = var.availability_zone["c"]

  tags = {
    Name = "${var.project-name}-private-c"
  }
}

## internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "${var.project-name}-igw"
  }
}

## route table
resource "aws_route_table" "public-a-rt" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project-name}-public-a-rt"
  }
}

resource "aws_route_table" "public-c-rt" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project-name}-public-c-rt"
  }
}

resource "aws_route_table" "private-a-rt" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "${var.project-name}-private-a-rt"
  }
}

resource "aws_route_table" "private-c-rt" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "${var.project-name}-private-c-rt"
  }
}

## route table association with vpc
resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public-a-rt.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public-c-rt.id
}

resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.private-a-rt.id
}

resource "aws_route_table_association" "private-c" {
  subnet_id      = aws_subnet.private-c.id
  route_table_id = aws_route_table.private-c-rt.id
}
