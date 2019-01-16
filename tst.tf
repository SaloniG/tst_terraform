provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAIV6IY6ZRU6QUJIRA"
  secret_key = "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"
}
resource "aws_vpc" "Terraform_demo_vpc" {
  cidr_block       = "10.0.0.0/19"
  instance_tenancy = "default"
}

resource "aws_subnet" "Terraform_demo_subnet" {
  vpc_id            = "${aws_vpc.Terraform_demo_vpc.id}"
  availability_zone = "us-east-2a"
  cidr_block        = "10.0.0.0/19"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "Terra_demo_IG" {
  vpc_id = "${aws_vpc.Terraform_demo_vpc.id}"
}

resource "aws_security_group" "terraform_demo_security_group" {
  name        = "terraform_demo"
 description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.Terraform_demo_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Terraform-demo-Ec2" {
  ami = "ami-15e9c770"
  instance_type = "t2.micro"
  key_name = "testaws"
  subnet_id = "${aws_subnet.Terraform_demo_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.terraform_demo_security_group.id}"]

