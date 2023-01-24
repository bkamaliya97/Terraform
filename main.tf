provider "aws" {
  region = "ap-south-1"
}

# creating vpc
resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "dev"
  }
}

# creating public subnet
resource "aws_subnet" "public-1" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "public-2"
  }
}

# creatig IGW
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev"
  }
}

# Route table for IGW
resource "aws_route_table" "dev-public" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }
  tags = {
    Name = "dev-public-1"
  }
}

# route table association
resource "aws_route_table_association" "dev-public-1-a" {
  subnet_id         = aws_subnet.public-1.id
  route_table_id = aws_route_table.dev-public.id
}

resource "aws_route_table_association" "dev-public-1-b" {
  subnet_id         = aws_subnet.public-2.id
  route_table_id = aws_route_table.dev-public.id
}

# creating ec2 in public subnet
resource "aws_instance" "ec2_public_1" {
  ami = "ami-0cca134ec43cf708f"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-1.id
  tags = {
    Name = "public_inst_1"
  }
}

resource "aws_instance" "ec2_public_2" {
  ami = "ami-0cca134ec43cf708f"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-2.id
  tags = {
    Name = "public_inst_2"
  }
}