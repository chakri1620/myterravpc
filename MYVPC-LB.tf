resource "aws_vpc" "myvpc" {
    cidr_block = var.vpc
  
}

resource "aws_subnet" "SN1" {
    cidr_block = var.subnet1
    availability_zone = var.az1
    vpc_id = aws_vpc.myvpc.id

    tags = {
        Name = "${var.tags}-sn1"
    }
  
}
resource "aws_subnet" "SN2" {
    cidr_block = var.subnet2
    availability_zone = var.az2
    vpc_id = aws_vpc.myvpc.id

    tags = {
        Name ="${var.tags}-sn2"
    }

  
}

resource "aws_subnet" "SN3" {
     cidr_block = var.subnet3
     availability_zone = var.az3
     vpc_id = aws_vpc.myvpc.id

     tags = {
        Name = "${var.tags}-sn3"
     }
}
resource "aws_subnet" "SN4" {
    cidr_block = var.subnet4-priv
    availability_zone = var.az4
    vpc_id = aws_vpc.myvpc.id

    tags = {
        Name = "${var.key}-sn4"
    }
}

resource "aws_subnet" "SN5" {
    cidr_block = var.subnet5-priv
    availability_zone = var.az5
    vpc_id = aws_vpc.myvpc.id

    tags = {
        Name = "${var.key}-sn5"
    
    }
  
}

resource "aws_subnet" "SN6" {
    cidr_block = var.subnet6-priv
    availability_zone = var.az6
    vpc_id = aws_vpc.myvpc.id

    tags = {
        Name = "${var.key}-sn6"
    }
  
}
resource "aws_internet_gateway" "IG" {
    vpc_id = aws_vpc.myvpc.id

    tags = {
        Name = "MY-IG"
    }
  
}
resource "aws_nat_gateway" "NG" {
    allocation_id = aws_eip.MY-EIP.id
    subnet_id = aws_subnet.SN1.id

    tags = {
        Name = "MY-NG"
    }

  
}
resource "aws_eip" "MY-EIP" {
  
}
resource "aws_route_table" "route-pub" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = var.route-pub
        gateway_id = aws_internet_gateway.IG.id
    }
     tags = {
        Name = "route-pub"
     }
  
}

resource "aws_route_table" "route-priv" {
    vpc_id = aws_vpc.myvpc.id
    
    tags = {
        Name = "route-priv"
    }
  
}
resource "aws_route_table_association" "pub1" {
    subnet_id = aws_subnet.SN1.id
    route_table_id = aws_route_table.route-pub.id
  
}
resource "aws_route_table_association" "pub2" {
    subnet_id = aws_subnet.SN2.id
    route_table_id = aws_route_table.route-pub.id
  
}
resource "aws_route_table_association" "pub3" {
    subnet_id = aws_subnet.SN3.id
    route_table_id = aws_route_table.route-pub.id
  
}
resource "aws_route_table_association" "priv1" {
    subnet_id = aws_subnet.SN4.id
    route_table_id = aws_route_table.route-priv.id
  
}
resource "aws_route_table_association" "priv2" {
    subnet_id = aws_subnet.SN5.id
    route_table_id = aws_route_table.route-priv.id
  
}
resource "aws_route_table_association" "priv3" {
    subnet_id = aws_subnet.SN6.id
    route_table_id = aws_route_table.route-priv.id
  
}
resource "aws_security_group" "MY-SG" {
    vpc_id = aws_vpc.myvpc.id
    ingress {
    from_port        = "443"
    to_port          = "443"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}
resource "aws_lb" "prac-lb" {
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.MY-SG.id]
    subnets = [aws_subnet.SN4.id,aws_subnet.SN5.id,aws_subnet.SN6.id]

    enable_deletion_protection = true
     tags ={
        Name = "MY-LB"
     }
}

