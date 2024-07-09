provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/20"
    enable_dns_hostnames = true
    tags ={
        Name = "my-vpc"
    }
}

resource "aws_subnet" "public-1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "public-1"
    }
}
resource "aws_subnet" "private-1"{
    cidr_block = "10.0.3.0/24"
    vpc_id = aws_vpc.vpc.id
    availability_zone = "ap-southeast-1a"
    tags = {
        Name = "private-1"
    }
}

