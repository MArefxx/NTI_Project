resource "aws_internet_gateway" "EKSvpc-igw" {
  vpc_id = aws_vpc.EKSvpc.id

  tags = {
    Name = "EKSvpc-igw"
  }
}