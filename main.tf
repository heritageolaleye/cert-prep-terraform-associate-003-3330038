 resource "aws_instance" "ec2-instance1" {
   ami = "ami-05b10e08d247fb927"
   instance_type = "t2.micro"

   tags = {                                
     Name = "demo-server1"
}
}