resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

}


data "aws_availability_zones" "aws-az" {
  state = "available"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

}

# resource "aws_subnet" "subnet_public" {
#   vpc_id = "${aws_vpc.vpc.id}"
#   cidr_block = "10.1.0.0/24"
#   map_public_ip_on_launch = "true"
#   availability_zone = "${var.availability_zone[0]}"

# }

resource "aws_subnet" "subnet_public" {
  count                   = length(data.aws_availability_zones.aws-az.names)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
  availability_zone       = data.aws_availability_zones.aws-az.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.igw.id}"
  }

}

# resource "aws_route_table_association" "rta_subnet_public" {
#   subnet_id      = aws_subnet.subnet_public.id
#   route_table_id = aws_route_table.rtb_public.id
# }

resource "aws_main_route_table_association" "aws-route-table-association" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.rtb_public.id
}


resource "aws_security_group" "lb" {
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

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "cb-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
