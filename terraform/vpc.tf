resource "aws_vpc" "vpc" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

}

resource "aws_subnet" "subnet_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "10.1.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.availability_zone}"

}

resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }

}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "${aws_subnet.subnet_public.id}"
  route_table_id = "${aws_route_table.rtb_public.id}"
}

variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "us-east-1a"
}

resource "aws_security_group" "sg_22_80" {
  name = "sg_22"
  vpc_id = "${aws_vpc.vpc.id}"

  # SSH access from the VPC
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
