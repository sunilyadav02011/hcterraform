data "aws_vpc" "main" {
    id = var.vpc_id
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.main.id
}

resource "aws_security_group" "sg_my_securitygroup01" {
  name        = "sg_mywebserver01"
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
    description      = "web"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip_with_cidr]
    ipv6_cidr_blocks = []
    prefix_list_ids=[]
    security_groups=[]
    self=false
  }
  
  egress {
      description = "outgoing traffic"
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
    key_name = "deployer-key"
    public_key = var.public_key
}

data "template_file" "user_data" {
    template = file("${abspath(path.module)}/userdata.yml")
}

data "aws_ami" "amazon-linux-2" {
    
    most_recent=true
    owners=["amazon"]
    filter{
        name="owner-alias"
        values=["amazon"]
    }
    filter{
        name="name"
        values=["amzn2-ami-hvm*"]

    }
  
}
resource "aws_instance" "web" {
    ami="${data.aws_ami.amazon-linux-2.id}"
    instance_type=var.instance_type
    vpc_security_group_ids=[aws_security_group.sg_my_securitygroup01.id]
    user_data=data.template_file.user_data.rendered
    subnet_id = tolist(data.aws_subnet_ids.subnet_ids.ids)[0]
    key_name = "${aws_key_pair.deployer.key_name}"

    tags={
        name=var.server_name
    }
}

