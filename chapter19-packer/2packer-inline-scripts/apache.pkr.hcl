variable    "ami_id"{
    type    = string
    default= "ami-0c02fb55956c7d316"
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
    tags={
        name=local.app_name
        OS_VERSION="Amazon"
    }
}

build {
    sources=["source.amazon-ebs.httpd"]
    provisioner "shell" {
        inline=[
            "sudo yum install -y httpd",
            "sudo systemctl start httpd",
            "sudo systemctl enable httpd",
        ]
    }

    
}
