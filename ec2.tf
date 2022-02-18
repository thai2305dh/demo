resource "aws_instance" "tf-ec2" {
    ami = "ami-0fb653ca2d3203ac1" //Phiên bản HĐH
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private.id
    # key_pair_id = data.aws_key_pair.tf-key
     associate_public_ip_address = true
    security_groups = [aws_security_group.tf-sg.id]
    key_name = "tf-ke2y"
 


    user_data     = <<-EOF
                  #!/bin/bash 
                  sudo su
                  yum -y update
                  amazon-linux-extras install nginx1.12-y
                  systemctl start nginx.service
                  systemctl enable nginx.service
				          amazon-linux-extras install php7.3
				          yum install php-xml php-mbstring
				          service php-fpm start
				          service nginx restart
				  
                  EOF 
}
resource "aws_security_group" "tf-sg" {
    name = "tf-sg"
    vpc_id = aws_vpc.vpc-thai.id
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
# resource "tls_private_key" "tf-prk" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
resource "aws_key_pair" "tf-ke2y" {
  key_name = "tf-ke2y"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5qDOZ1kH1Gr/9vyHZA/wR1oESZH42no/kTOhnPUKmt/uWyL3dU8IqgRSyqzxP3Pc+IYqdXU1A4J8MOLOS9GqtpzDjWFyQ9eYOrpCwxZF/TT6Wo59LzKnQEcZJuazukve5k4AlOfC9UhLIJEy1ZRWhxSJ5nu8131X4SFV9hrT9ytz+moG1KYUBvjpqntjyuomm46Qf68dZK+vPWcoDXnTfHl/3YqYUFjmxGtqfDC2jiMCNumsrrDmOxQi8IOagM8HsznzS4TDp5ocOQUFHzFO3gEY+eYwQ/gpKzBRT8AemIAwrLtSkA5SSjOWQhma+cXWETfNlSFeczXC/BHQ1V9WczTMqunFIGgmUFDHXHuAWyMe87CcEbbmcltdtJKAN8Tu1hxiSWSv490uY4uJUjpwyEJaPC1ihF+2GYjPt1831NBCOXNGlPz6UW7RfLO7NpLxEDb7JDkmYCQUXpJtyFfgKszG7T599T6ZVtidHNCq5BzX2VH4zW3+Wifvl5kaEdnc= yeu@kali"

}
# resource "aws_key_pair" "thaikey"{
#     key_name = "thaikey"
#     id = "key-083c1af393db45979"
# }
# data "aws_key_pair" "thaikey" {
#   key_pair_id = "key-083c1af393db45979"
#   filter {
#     name   = "tag:Component"
#     values = ["web"]
#   }
# }