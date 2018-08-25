provider "aws" {
  region     = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"

  tags {
    Name = "network",
    Environment = "dev"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "Main"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.0.0/24"

  tags {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "default" {
 vpc_id = "${aws_vpc.main.id}"
 tags {
   Name = "default-ig"
 }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public-route-table-assocation" {
  subnet_id = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-route-table.id}"
}
