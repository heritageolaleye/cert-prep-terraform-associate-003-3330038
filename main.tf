resource "tls_private_key" "web" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "aws_key_pair" "web_app_key_pair"{
  key_name = "web_app_key_pair"
  public_key = tls_private_key.web.public_key_openssh
}
resource "local_file" "private_key" {
  filename = "${path.module}/web-app-key-pair.pem"
  content = tls_private_key.web_app_key.private_key.pem
  file_permission = "0400"
}
resource "aws_security_group" "web_sg" {
  name = "web-app-sg"
  description = "Allow SSH and HTTP access" 

ingress {
  description = "Allow SSH"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
ingress {
  description = "Allow HTTP"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
egress {
  description = "Allow all outbound traffic"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  Name = "web App Security Group"
}
}

data "aws_vpc" "default" {
  default = true
}
data "aws_subnet" "default_subnet" {
  vpc_id = data.aws_vpc.default.vpc_id
  availabilty_zone =  "us-east-1a"
}

resource "aws_instance" "ec2-instance1" {
  ami = "ami-05b10e08d247fb927"
   instance_type = "t2.micro"
   key_name =aws_key_pair.web_app_key_pair.key_name

   vpc_security_group_ids = [aws_security_group.web_sg.id]
   subnet_id = data.aws_subnet.default_subnet.id

   tags = {                                
     Name = "demo-server1"
}
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "pem_file_path" {
  value = local_file.private_key.filename
}