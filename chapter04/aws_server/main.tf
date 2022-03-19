terraform {  
  required_providers {
    aws={
      source="hashicorp/aws"
      version="3.59.0"
    }
  }
}

variable "instance_type" {
    type = string
    description = "this is instance type"
    #sensitive=  true
    validation {
      condition = can( regex ("^t2.",var.instance_type))
      error_message = "The instance must be t2 size."
      }
}
provider "aws"{
  region = "us-east-1"  
}
resource "aws_instance" "web" {
    ami="ami-033b95fb8079dc481"
    instance_type=var.instance_type
}

output "public_ip"{
    value=aws_instance.web.public_ip
}