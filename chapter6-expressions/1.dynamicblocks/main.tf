terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.6.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "default"
  region = "us-east-1"
}

data "aws_vpc" "main" {
    id="vpc-0515341caa2b88c6c"
  
}


locals {
  ingress= [{
      port=443
      description= "port 443"
      protocol= "tcp"
  }]
}
resource "aws_security_group" "allow_tls" {
  name = "allow_tls"
  description = "allow tls inbound traffic"
  vpc_id=data.aws_vpc.main.id

    dynamic "ingress"{
        for_each=local.ingress
        content {
            description      = ingress.value.description
            from_port        = ingress.value.port
            to_port          = ingress.value.port
            protocol         = ingress.value.protocol
            cidr_blocks      = [data.aws_vpc.main.cidr_block]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self= false
        }

    }

  egress {
    description= "outgoing for all"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids = []
    security_groups = []
    self= false

  }

  tags = {
    Name = "allow_tls traffic"
  }
}