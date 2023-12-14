provider "aws" {
    region = "ap-southeast-1"
}

#securitygroup using Terraform

resource "aws_security_group" "TF_SG" {
  name        = "metrics SG"
  description = "metrics security group using Terraform"
  vpc_id      = "vpc-0a5cc043287a0b892"

  ingress {
    description      = "prometheus"
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "grafana"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "prometheus Node Exporter"
    from_port        = 9100
    to_port          = 9100
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}

#instances using Terraform

resource "aws_instance" "web1" {
  ami             = "ami-03caf91bb3d81b843"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.TF_SG.name]
  key_name = data.aws_key_pair.existing_key_pair.key_name

  tags = {
    Name = "prometheus+grafana"
  }
}


resource "aws_instance" "web2" {
  ami             = "ami-03caf91bb3d81b843"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.TF_SG.name]
  key_name = data.aws_key_pair.existing_key_pair.key_name

  tags = {
    Name = "node_exporter"
  }
}







