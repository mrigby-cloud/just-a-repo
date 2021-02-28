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

  ingress {
    from_port   = 0
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

resource "aws_instance" "stock-check" {
  ami           = "ami-0915bcb5fa77e4892"
  instance_type = "t2.micro"
  key_name = "aws_id_rsa"
  vpc_security_group_ids = [aws_security_group.stock-check-sec-group.id]

  provisioner "remote-exec" {
    inline = ["touch /tmp/thisworks"]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/aws_id_rsa")
    }
  }
  provisioner "local-exec" {
    command = "sudo ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user -i '${self.public_ip},' --private-key ~/.ssh/aws_id_rsa stock-config.yml"
  }

  tags = {
    Name = var.instance_name
  }
}


