terraform {
  
}

provider   "aws"{
    region= "us-east-1"
 
}

module "apache" {
    source=".//terraform-aws-apache-example"
    vpc_id="vpc-04ef14cab0d6b007d"   
    my_ip_with_cidr= "42.105.72.24/32"
    public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDdHSabGzWPrU3ROrgxwC98vpSFfaeY+Zj3XJp8jb2ybMquMOUfpd+9vIo3QcwojfhUnnObPPjg/z+r2KqLZxzZCPFCRUKlk6qZ7Zhmw8YP9Zm+PrJAnV50XMOCiuTrwa4x6gsPwcOkZom65brpT6Vvc20icYTsZE1MuinSQW+e23YrVAPRpHCrFWE5RJJdHAfZvWu4CuHotzzTN/tpYvtKDea9lTcjyibQqVnQv7MumhWVvlHURuIMXrbzB/uoTwJpgtXsjLalxw3JIGj8Tb630CG4G28HkVEH9D6k6shOAdzwRjs6U0PmuyCyquMVq4VkHJXBf8/QjAwv6OQ5RxBMzMAjE/9Pq1N46OlUbfxCWFQbtwD5taI+AlTWMs6Gvgz6fw04VBYq2nBUj0E37vzBvvnZ8KKSmt17AeL0qDv7z1eLcgjypJfKdgcmkxP53FcbRdSTFSLKrycMTJw5GuNO+j3aCG6OECoAD9qLo1txxiSXQJzAch2QiERaBkrVw0= ivan@azskaquatest001"   
    instance_type= "t2.micro"
    server_name="Apache example server" 
      
}


