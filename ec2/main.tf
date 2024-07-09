provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "hello" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = var.instance_type

  subnet_id = "subnet-0a7e9558bb3fca063"
  associate_public_ip_address = "false"
  tags = {
    Name = "Hello"
  }
}