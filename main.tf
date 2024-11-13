resource "aws_vpc" "vpc7" {
  cidr_block = "10.111.0.0/16"
  tags = {
    Name = "user7VPC"
  }
}
