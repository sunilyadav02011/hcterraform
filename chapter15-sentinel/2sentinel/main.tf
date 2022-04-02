terraform {
    backend "remote" {
        hostname = "app.terraform.io"
        organization = "sklearnit"
        workspaces {
          name="terraform-vcs"
        }
      
    }
}

provider   "aws"{
    region= "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
    bucket=var.bucket_name
  
}
module "ec2" {
    source  = "app.terraform.io/sklearnit/ec2/aws"
    version = "1.0.1"
    vpc_id=var.vpc_id  
    my_ip_with_cidr= var.my_ip_with_cidr
    public_key=var.public_key   
    instance_type= var.instance_type
    server_name=var.server_name
  
}

