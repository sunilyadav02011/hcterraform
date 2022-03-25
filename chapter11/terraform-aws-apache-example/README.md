This is Terraform module for EC2 Instance

```hcl
terraform {
  
}

provider   "aws"{
    region= "us-east-1"
 
}

module "apache" {
    source=".//terraform-aws-apache-example"
    vpc_id="vpc-00000"   
    my_ip_with_cidr= "Your_IP/32"
    public_key="ssh-rsa AAAAB3NzaC"   
    instance_type= "t2.micro"
    server_name="Apache example server" 
      
}


```