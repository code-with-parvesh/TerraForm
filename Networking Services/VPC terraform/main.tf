
// Create Vpc

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

// Create subnet
resource "aws_subnet" "demo-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "demo-subnet"
  }
}

// Create Internet Gateway
resource "aws_internet_gateway" "demo-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "demo-gw"
  }
}

// Create a route table
resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gw.id
  }

  tags = {
    Name = "demo-rt"
  }
}
// associate subnet with routetable
resource "aws_route_table_association" "demo-rt-association" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-rt.id
}

// Security group
resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {

    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
// Create ec2 instance
  provider "aws" {
    region = "us-east-1"
  }
resource "aws_instance" "my_vm" {
    ami = "ami-09d56f8956ab235b3"
    instance_type ="t2.micro"
  
  
 subnet_id = aws_subnet.demo-subnet.id
 vpc_security_group_ids = [ aws_security_group.demo-vpc-sg.id ]


  tags = {
   Name = "My EC2 instance"
 }
}
