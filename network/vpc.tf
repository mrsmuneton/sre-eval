# variable "vpc_id" {}
provider "aws" {
  region     = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "network",
    Environment = "dev"
  }
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}

resource "aws_internet_gateway" "default" {
 vpc_id = "${aws_vpc.main.id}"
}
