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
resource "aws_instance" "web" {
    for_each={
      micro="t2.micro"
      
    }
    ami="ami-033b95fb8079dc481"
    instance_type=each.value
    tags = {
      "name" = "Server-${each.key}"
    }
    lifecycle {
      prevent_destroy=false
    }
}

output "public_ip"{
    value=values(aws_instance.web)[*].public_ip
}


