terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "stock-check" {
  ami           = "ami-0915bcb5fa77e4892"
  instance_type = "t2.micro"
  key_name = "aws_id_rsa"
  vpc_security_group_ids = [aws_security_group.stock-check-sec-group.id]

  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "aws_key" {
  key_name   = "aws_id_rsa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdzG50ljkKy+BVkdLy74Utd0sjGFPGqAEqVgeGzGBE2MUgzBz5gz9X0BELabpvKDOqXmBsD2xKT3jWmvBMelS+lMNT0iKOIA868PPtq1DOpQ3/fYhu06KCwXQ5cI76Ll9fEWMfgC0oyxjBTSIGcjaTIm9rgKba3HTedB8uU+sEhuVUDox0a4EF7f6rsPqIBWsEFLR+wVldMcajrPAXpo+5RcTeO8j399hK2x0ceAablrP5dp9dpcexOHOqNG04VcQH0Ri4dE3TX/GTZPh0Z7WeZaLyvTGsQVgreali5RahM5twD1ZALXG9Y7vNoD9VQu3Rkfx5Vmp/kusC3nsLEEiD matt@G02UKXN06825"
}

resource "aws_security_group" "stock-check-sec-group" {
  name = "stock-check-sec-group"
  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}