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

data "aws_vpc" "main" {

    id="vpc-0c80ba7c534d673c5"
  
}

resource "aws_security_group" "sg_my_securitygroup" {
  name        = "sg_mywebserver"
  description = "My security group"
  vpc_id      = data.aws_vpc.main.id

  ingress   {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids=[]
    security_groups=[]
    self=false
  }

  ingress {
    description      = "ssh"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids=[]
    security_groups=[]
    self=false
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids=[]
    security_groups=[]
    self=false
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDdHSabGzWPrU3ROrgxwC98vpSFfaeY+Zj3XJp8jb2ybMquMOUfpd+9vIo3QcwojfhUnnObPPjg/z+r2KqLZxzZCPFCRUKlk6qZ7Zhmw8YP9Zm+PrJAnV50XMOCiuTrwa4x6gsPwcOkZom65brpT6Vvc20icYTsZE1MuinSQW+e23YrVAPRpHCrFWE5RJJdHAfZvWu4CuHotzzTN/tpYvtKDea9lTcjyibQqVnQv7MumhWVvlHURuIMXrbzB/uoTwJpgtXsjLalxw3JIGj8Tb630CG4G28HkVEH9D6k6shOAdzwRjs6U0PmuyCyquMVq4VkHJXBf8/QjAwv6OQ5RxBMzMAjE/9Pq1N46OlUbfxCWFQbtwD5taI+AlTWMs6Gvgz6fw04VBYq2nBUj0E37vzBvvnZ8KKSmt17AeL0qDv7z1eLcgjypJfKdgcmkxP53FcbRdSTFSLKrycMTJw5GuNO+j3aCG6OECoAD9qLo1txxiSXQJzAch2QiERaBkrVw0= ivan@azskaquatest001"
}


data "template_file" "users_data" {
    template = file("./userdata.yaml")
  
}
resource "aws_instance" "web" {
    ami="ami-033b95fb8079dc481"
    instance_type="t2.micro"
    vpc_security_group_ids=[aws_security_group.sg_my_securitygroup.id]
    user_data=data.template_file.users_data.rendered
    key_name = "${aws_key_pair.deployer.key_name}"
    provisioner "local-exec"{
      command= "echo ${self.private_ip} >> private_ips.txt"

    }
    provisioner "file"{
      content = "thisisme"
      destination="/home/ec2-user/abc.txt"
      connection {
        type = "ssh"
        user="ec2-user"
        host="${self.public_ip}"
        private_key = "${file("~/.ssh/id_rsa")}"
      }
    }
    

    
    tags={
        name="web-server"
    }
}

resource "null_resource" "status" {
  provisioner "local-exec" {
    command="aws ec2 wait instance-status-ok --instance-ids ${aws_instance.web.id}"
  }
  depends_on=[
    aws_instance.web
  ]
}
output "public_ip"{
    value=aws_instance.web.public_ip
}
output "private_ip" {
    value=aws_instance.web.private_ip
}