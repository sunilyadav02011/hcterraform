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
    ami="ami-033b95fb8079dc481"
    instance_type=local.instance_type
}

output "public_ip"{
    value=aws_instance.web.public_ip
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  depends_on = [
    aws_instance.web
  ]

}

