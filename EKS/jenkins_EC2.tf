# resource "aws_vpc" "VPC-NTI" {
#   cidr_block       = "10.0.0.0/16"
#   tags = {
#     Name = "VPC-NTI"
#   }
# }


# resource "aws_subnet" "public-subnet" {
#   vpc_id     = aws_vpc.VPC-NTI.id
#   cidr_block = "10.0.1.0/24"
#    tags = {
#     Name = "public-subnet"
#   }
# }

# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.VPC-NTI.id

#   tags = {
#     Name = "nti-GW"
#   }
# }


# resource "aws_route_table" "public-rt" {
#   vpc_id = aws_vpc.VPC-NTI.id
#    tags = {
#     Name = "public-rt"
#   }
#   }


#   resource "aws_route" "internet_gateway_route" {
#   route_table_id         = aws_route_table.public-rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.gw.id
# }



# resource "aws_route_table_association" "subnet-ass" {
#   subnet_id      = aws_subnet.public-subnet.id
#   route_table_id = aws_route_table.public-rt.id
# }




resource "aws_security_group" "web-sg" {
  name        = "web-sg"
  description = "Allow http inbound traffic "
  vpc_id      = aws_vpc.VPC-EKSvpc.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ping_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}


resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  
  }
  filter {
  name   = "virtualization-type"
  values = ["hvm"]  
}
  filter {
  name   = "architecture"
  values = ["x86_64"]  
}
  owners = ["099720109477"]
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.public-us-east-1b.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  key_name = "demo"
  tags = {
    Name = "jenkins"
  }
  root_block_device {
    volume_size = 16
  }

}
#resource "local_file" "ip_file" {
#  content  = aws_instance.web1.public_ip
#  filename = "/home/mohamed/test/inventory"
#}
# resource "aws_key_pair" "deployer" {
#   key_name   = "deployer-key"
#   public_key = file("/home/mohamed/.ssh/id_rsa.pub") 
# }
