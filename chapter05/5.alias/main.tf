terraform {  
  required_providers {
    aws={
      source="hashicorp/aws"
      version="3.59.0"
    }
  }
}

provider "aws"{
  profile = "default"
  region = "us-east-1" 
}
provider "aws"{
  profile = "default"
  region = "us-east-1" 
  alias="east" 
}

provider "aws"{
  profile = "default"
  region = "us-west-1" 
  alias="west" 
}

data  "aws_ami" "east-amazon-linux-2"{
  provider = aws.east
  most_recent = true
  owners=["amazon"]
  filter{
    name="owner-alias"
    values = ["amazon"]
  }
  filter {
    name="name"
    values=["amzn2-ami-hvm*"]
  }
}
data  "aws_ami" "west-amazon-linux-2"{
  provider = aws.west
  most_recent = true
  owners=["amazon"]
  filter{
    name="owner-alias"
    values = ["amazon"]
  }
  filter {
    name="name"
    values=["amzn2-ami-hvm*"]
  }
}

locals {
  instance_type ="t2.micro"
  
}
resource "aws_instance" "web_east" {

    ami=data.aws_ami.east-amazon-linux-2.id
    instance_type="t2.micro"
    provider = aws.east
    tags = {
      "name" = "Server-east"
    }
}

resource "aws_instance" "web_west" {

    ami=data.aws_ami.west-amazon-linux-2.id
    instance_type="t2.micro"
    provider = aws.west
    tags = {
      "name" = "Server-west"
    }
}

output "public_ip"{
    value=aws_instance.web_west.public_ip
}

