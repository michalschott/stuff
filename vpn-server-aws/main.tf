variable "region" {
  default = "eu-central-1"
}

variable "ami" {
  default = {
    eu-central-1 = "ami-fe408091"
  }
}

variable "vpc_cidr" {
  default = "10.155.0.0"
}

variable "trusted_ips" {
  default = ["0.0.0.0/0"]
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "key_name" {
  default     = "default"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}/16"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "default" {
  route_table_id         = "${aws_route_table.default.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_route_table_association" "default" {
  subnet_id      = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.default.id}"
}

resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.vpc_cidr}/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "default" {
  name   = "default"
  vpc_id = "${aws_vpc.default.id}"
  description = "default VPC security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.trusted_ips}"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["${var.trusted_ips}"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["${var.trusted_ips}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "web" {
  connection {
    user = "ubuntu"
    private_key = "file('~/.ssh/id_rsa')"
  }

  instance_type          = "t2.micro"
  ami                    = "${lookup(var.ami, var.region)}"
  key_name               = "${aws_key_pair.auth.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id              = "${aws_subnet.default.id}"
  user_data              = "${file("${path.module}/vpn-setup.sh.tpl")}"

  provisioner "remote-exec" {
    inline = [
      "sudo yum upgrade -y",
    ]
  }
}
