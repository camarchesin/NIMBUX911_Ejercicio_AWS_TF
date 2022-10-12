####  CLOUD PROVIDER   #################################################
provider "aws" {
  access_key = var.provider_access_key
  secret_key = var.provider_secret_key
  region     = var.provider_region
}
####  VPC  #############################################################
resource "aws_vpc" "VPC_1" {
  cidr_block       = var.vpc_cidr_block
    tags = {
    Name = "Vpc-1"
  }
}
####  SUBNETS ##########################################################
resource "aws_subnet" "PUB_SNET_1" {
  vpc_id     = aws_vpc.VPC_1.id
  cidr_block = var.pub_snet_1_cidr_block
 availability_zone = var.availability_zone_1
  tags = {
    Name = "Public-Subnet-1"
  }
}
resource "aws_subnet" "PRV_SNET_1" {
  vpc_id     = aws_vpc.VPC_1.id
  cidr_block = var.prv_snet_1_cidr_block 
 availability_zone = var.availability_zone_1
  tags = {
    Name = "Private-Subnet-1"
  }
}
resource "aws_subnet" "PUB_SNET_2" {
  vpc_id     = aws_vpc.VPC_1.id
  cidr_block = var.pub_snet_2_cidr_block
 availability_zone = var.availability_zone_2
  tags = {
    Name = "Public-Subnet-2"
  }
}
resource "aws_subnet" "PRV_SNET_2" {
  vpc_id     = aws_vpc.VPC_1.id
  cidr_block = var.prv_snet_2_cidr_block
 availability_zone = var.availability_zone_2
   tags = {
    Name = "Private-Subnet-2"
  }
}
####  INTERNET GATEWAY  ################################################
resource "aws_internet_gateway" "INET_GW_1" {
  vpc_id = aws_vpc.VPC_1.id
  tags = {
    Name = "Internet-Gateway-Vpc-1"
  }
}
####  ELASTIC IPS  #####################################################
resource "aws_eip" "EIP_NAT_GW_1" {
  vpc = true
}
resource "aws_eip" "EIP_NAT_GW_2" {
  vpc = true
}
####  NAT GATEWAY  #####################################################
resource "aws_nat_gateway" "NAT_GW_1" {
  depends_on = [aws_internet_gateway.INET_GW_1]
  allocation_id = aws_eip.EIP_NAT_GW_1.id
  subnet_id     = aws_subnet.PUB_SNET_1.id
  tags = {
    Name = "Nat-Gateway-to-Public-Subnet-1"
  }
}
resource "aws_nat_gateway" "NAT_GW_2" {
  depends_on = [aws_internet_gateway.INET_GW_1]
  allocation_id = aws_eip.EIP_NAT_GW_2.id
  subnet_id     = aws_subnet.PUB_SNET_2.id
  tags = {
    Name = "Nat-Gateway-to-Public-Subnet-2"
  }
}
####  ROUTE TABLES  ####################################################
resource "aws_route_table" "PUB_SNET_RT_1" {
  vpc_id = aws_vpc.VPC_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.INET_GW_1.id
  }
  tags = {
    Name = "Public-Subnet-Route-Table-to-Internet-Gateway"
  }
}
resource "aws_route_table" "PRV_SNET_RT_1" {
  vpc_id = aws_vpc.VPC_1.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GW_1.id
  }
  tags = {
    Name = "Private-Subnet-Route-Table-to-Nat-Gateway-1"
  }
}
resource "aws_route_table" "PRV_SNET_RT_2" {
  vpc_id = aws_vpc.VPC_1.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GW_2.id
  }
  tags = {
    Name = "Private-Subnet-Route-Table-to-Nat-Gateway-2"
  }
}
####  ROUTE TABLES ASSOCIATION  ########################################
resource "aws_route_table_association" "PUB_SNET_RT_ASC_1" {
  subnet_id      = aws_subnet.PUB_SNET_1.id
  route_table_id = aws_route_table.PUB_SNET_RT_1.id
}
resource "aws_route_table_association" "PUB_SNET_RT_ASC_2" {
  subnet_id      = aws_subnet.PUB_SNET_2.id
  route_table_id = aws_route_table.PUB_SNET_RT_1.id
}
resource "aws_route_table_association" "PRV_SNET_RT_ASC_1" {
  subnet_id      = aws_subnet.PRV_SNET_1.id
  route_table_id = aws_route_table.PRV_SNET_RT_1.id
}
resource "aws_route_table_association" "PRV_SNET_RT_ASC_2" {
  subnet_id      = aws_subnet.PRV_SNET_2.id
  route_table_id = aws_route_table.PRV_SNET_RT_2.id
}
####  SECURITY GROUPS  #################################################
resource "aws_security_group" "ALB_SG_1" {
  name        = "ALB-Security-Group-1"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.VPC_1.id
  ingress {
    description      = "Allow ingress HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   }
  egress {
    description      = "Allow egress all traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow HTTP traffic to ALB"
  }
}
resource "aws_security_group" "EC2_SG_1" {
  depends_on = [aws_security_group.ALB_SG_1]
  name        = "EC2-Security-Group-1"
  description = "Allow HTTP traffic from ALB to EC2 webservers"
  vpc_id      = aws_vpc.VPC_1.id
  ingress {
    description      = "Allow HTTP traffic from ALB"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = ["${aws_security_group.ALB_SG_1.id}"]
  }
  egress {
    description      = "Allow egress all traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow HTTP traffic from ALB to EC2 webservers"
  }
}
####  APPLICATION LOAD BALANCER  ########################################
resource "aws_lb" "ALB_1" {
  name              = "App-Load-Balancer-1"
  internal           = false
  load_balancer_type = "application"
  security_groups  = [aws_security_group.ALB_SG_1.id]
  subnets          = [aws_subnet.PUB_SNET_1.id,aws_subnet.PUB_SNET_2.id]       
  tags = {
        name  = "App-Load-Balancer-1"
   }
}
####  ALB LISTENER  ######################################################
resource "aws_lb_listener" "ALB_LISTENER_1" {
  load_balancer_arn = aws_lb.ALB_1.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB_TG_1.arn
  }
}
####  ALB TARGET GROUP  ##################################################
resource "aws_lb_target_group" "ALB_TG_1" {
  name        = "ALB-Target-Group-1"
 target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.VPC_1.id
  health_check {
    enabled = true
    path = "/"
    port = "80"
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 2
    interval = 90
    timeout = 20
    matcher = "200"
  }
}
####  ALB TARGET GROUP  ATTACHMENT  #######################################
resource "aws_lb_target_group_attachment" "ALB_TG_ATCH_1" {
  depends_on = [aws_instance.EC2_WSRV_1]
  target_group_arn = aws_lb_target_group.ALB_TG_1.arn
  target_id        = aws_instance.EC2_WSRV_1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "ALB_TG_ATCH_2" {
  depends_on = [aws_instance.EC2_WSRV_2]
  target_group_arn = aws_lb_target_group.ALB_TG_1.arn
  target_id        = aws_instance.EC2_WSRV_2.id
  port             = 80
}
####  EC2 INSTANCES  ######################################################
resource "aws_instance" "EC2_WSRV_1" {
  ami           = var.instance_ami
  instance_type = var.instance_type
    availability_zone = var.availability_zone_1
  subnet_id = aws_subnet.PRV_SNET_1.id
  vpc_security_group_ids = ["${aws_security_group.EC2_SG_1.id}"]
  user_data = "${file("install_wsrv_1.sh")}"
  #<<-EOF
  #                #!/bin/bash
  #                sudo apt-get update
  #                sudo apt-get install -y nginx
  #                sudo systemctl start nginx
  #               EOF
  tags = {
    Name = "${var.instance_ec2_wsrv_1_tag_name}" 
  }
}
resource "aws_instance" "EC2_WSRV_2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  availability_zone = var.availability_zone_2
  subnet_id = aws_subnet.PRV_SNET_2.id
  vpc_security_group_ids = ["${aws_security_group.EC2_SG_1.id}"]
    user_data = "${file("install_wsrv_2.sh")}"
 #   <<-EOF
 #                   #!/bin/bash
 #                   sudo apt-get update
 #                   sudo apt-get install -y apache2
 #                   sudo systemctl start apache2
 #                EOF
#"${file("install_nginx.sh")}"
  tags = {
    Name = "${var.instance_ec2_wsrv_2_tag_name}"
  }
}

