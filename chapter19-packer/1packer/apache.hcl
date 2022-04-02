variable    "amid_id"{
    type    = string
    default= 
}

locals {
  app_name  = "httpd"
}

source  "amazon-ebs" "httpd" {
    ami_name="my-server-${local.app_name}"
    instance_type="t2.micro"
    region="us-east-1"
    source_ami="${var.ami_id}"
    ssh_username="ec2-user"
    tags {
        Name= local.app_name
    }
}

build {
    sources=["source.amazon-ebs.httpd"]
    provisioner "shell" {
        script="userdata.sh"
    }
    
}
