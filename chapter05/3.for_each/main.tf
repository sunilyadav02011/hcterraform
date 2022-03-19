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
}

locals {
  instance_type ="t2.micro"
  
}
resource "aws_instance" "web" {
    for_each={
      nano="t2.nano"
      micro="t2.micro"
      small="t2.small"
    }
    ami="ami-033b95fb8079dc481"
    instance_type=each.value
    tags = {
      "name" = "Server-${each.key}"
    }
}

output "public_ip"{
    value=values(aws_instance.web)[*].public_ip
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  depends_on = [
    aws_instance.web
  ]

}

