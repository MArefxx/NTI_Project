# elastic ip
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat"
  }
}
#nat_gateway
resource "aws_nat_gateway" "EKS-nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name = "EKS-nat"
  }

  depends_on = [aws_internet_gateway.EKSvpc-igw]
}