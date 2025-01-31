resource "aws_instance" "ec2-instance" {
    #instance configuration
    ami = "ami-08d4f6bbae664bd41"
    instance_type = "t2.micro"

    tags = {
      Name = "demo-1"
    }
}