resource "aws_instance" "vm" {
  ami =  "ami-0866a3c8686eaeeba"
  instance_type = var.vmsize
  subnet_id = aws_subnet.mysubnet1.id
  vpc_security_group_ids = [ aws_security_group.dev-sg.id ]
  key_name = "ec2-dev-250-key"
  user_data = <<-EOF
    #!bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "welcome to web server depolyed using TF" >/var/www/html/index.html
    EOF
  tags = {
    "Name" = "Myvm7"
  }
}

resource "tls_private_key" "devk1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-dev-250-key"
  public_key = tls_private_key.devk1.public_key_openssh

  tags = {
    Name = "ec2-dev-tls-key"
  }
}

resource "local_file" "devk1_pem" {
  filename        = "ec2-dev-250-key.pem"
  content         = tls_private_key.devk1.private_key_pem
  file_permission = "0400" # Ensure the file is only readable by the owner
}

output "private_key_path" {
  value = local_file.devk1_pem.filename
}


resource "aws_eip" "eip" {
  instance = aws_instance.vm.id
  depends_on = [ aws_internet_gateway.igway ]
  tags = {
    Name = "ec2-elastic-IP"
  }
}
output "Myvm7-IP" {
  value = aws_instance.vm.public_ip
}
output "Myvpc7-ID" {
  value = aws_vpc.myvpc.id
}
    