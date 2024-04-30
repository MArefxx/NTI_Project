# Create a VPC
resource "aws_vpc" "EKSvpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "EKSvpc"
  }
}
