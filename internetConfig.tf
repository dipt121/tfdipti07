#Create Internet Gateway
resource "aws_internet_gateway" "igway" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    "Name" = "igateway"
  }
}

#Create Route Table - attached with subnet
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id
}
#Create Route in Route Table for Internet Access
resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igway.id
}

#Associate Route Table with Subnet
resource "aws_route_table_association" "rt-assoc" {
  route_table_id = aws_route_table.rt.id
  subnet_id      = aws_subnet.mysubnet1.id
}

#Create Security Group in the VPC with port 80, 22 as inbound open
resource "aws_security_group" "dev-sg" {
  name        = "dev-web-ssh-sg"
  vpc_id      = aws_vpc.myvpc.id
  description = "Dev web server traffic allowed ssh & http"

}

resource "aws_vpc_security_group_ingress_rule" "dev-ingress-22" {
  security_group_id = aws_security_group.dev-sg.id
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "dev-ingress-80" {
  security_group_id = aws_security_group.dev-sg.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "dev-egress" {
  security_group_id = aws_security_group.dev-sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
