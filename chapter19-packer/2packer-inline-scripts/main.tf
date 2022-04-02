terraform {  
  required_providers {
    aws={
      source="hashicorp/aws"
      version="3.59.0"
    }
  }
}

provider "aws"{
  region = "us-east-1"  
  profile = "default"
}

locals {
  instance_type ="t2.micro"
  
}

data "aws_ami" "packer_image" {
  #executable_users =  ["self"] 
  #most_recent = true
  #name_regex ="^my-server.*"
  owners="self"
  filter {
    name="name"
    values=["my-server-httpd"]
  }
}
resource "aws_instance" "web" {
    for_each={
      micro="t2.micro"
      
    }
    ami=data.aws_ami.packer_image.id
    instance_type=each.value
    tags = {
      "name" = "Server-packer"
    }
    lifecycle {
      prevent_destroy=false
    }
}

output "public_ip"{
    value=aws_instance.web.public_ip
}


