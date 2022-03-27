terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=4.6.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "default"
  region = "us-east-1"
}

resource "aws_instance" "my_server"{
    ami = "ami-0c02fb55956c7d316"
    instance_type  =    "t2.micro"
    tags={
        name="my_server"
    }
}

output "server_ip" {
    value = aws_instance.my_server[*].public_ip
  
}