# create Instance cho 2 autoscalling group
resource "aws_launch_configuration" "launch_instance_config-1" {
  
    name = "terraform-launch-instance-config-tf-client"
    image_id = var.terraform-ubuntu-ami //Phiên bản HĐH
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.tf-sg-private.id}"] // sercurity group cho instance
    key_name = "key"
    associate_public_ip_address = true

  user_data = <<-EOF
    !/bin/bash
    sudo apt-get update
    sudo apt install httpd php mysql php-mysql
    chkconfig httpd on
    service httpd start
    cd /var/www/html
    echo "<html><h1> Xin chao 1 </h1></html>" > index.html
    chown apache:root /var/www/html/rds.conf.php
  EOF
  
  lifecycle {
      create_before_destroy = true
  }
}
resource "aws_launch_configuration" "launch_instance_config-2b" {
  
    name = "terraform-launch-instance-config-tf-server"
    image_id = var.terraform-ubuntu-ami //Phiên bản HĐH
    security_groups = ["${aws_security_group.tf-sg-private.id}"]
    instance_type = "t2.micro"
    key_name = "key"
    associate_public_ip_address = true

  user_data = <<-EOF
    !/bin/bash
    sudo apt-get update
    sudo apt install httpd php mysql php-mysql
    chkconfig httpd on
    service httpd start
    cd /var/www/html
    echo "<html><h1> Xin chao 2 </h1></html>" > index.html
    chown apache:root /var/www/html/rds.conf.php
  EOF
  
  lifecycle {
      create_before_destroy = true
  }
}

# Autoscalling group
resource "aws_autoscaling_group" "asg-tf1" {
  
  launch_configuration = aws_launch_configuration.launch_instance_config-1.id // Instance mẫu
  vpc_zone_identifier = [ aws_subnet.private-subnet-1a.id ]
  
  min_size = 1 // Số lượng instance tối thiểu
  max_size = 2  // Số lượng instance tối đa

  load_balancers = [aws_elb.elb-1.name] // Gán cho ELB
  health_check_type = "ELB"  

  tag {
    key = "Name"
    value = "terraform-asg-client"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_group" "asg-tf2" {
  
  launch_configuration = aws_launch_configuration.launch_instance_config-2b.id

  vpc_zone_identifier = [ aws_subnet.private-subnet-1b.id ]
  
  min_size = 1
  max_size = 2

  load_balancers = [aws_elb.elb-2.name]
  health_check_type = "ELB"  

  tag {
    key = "Name"
    value = "terraform-asg-server"
    propagate_at_launch = true
  }
}