#VPC
resource "aws_vpc" "vpc" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames  = true
  enable_dns_support     = true

  tags = {
    Name                = "${var.environment}-vpc"
    Environment         = var.environment
  }
}

## Subnets 

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name        = "nat"
    Environment = "${var.environment}"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.environment}"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id


  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


# Default Security Group of VPC
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on = [
    aws_vpc.vpc
  ]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.environment}"
  }
}

# resource "aws_instance" "web_instance" {
#   ami           = "ami-04d9e855d716f9c99"
#   instance_type = "t2.micro"
#   key_name      = "PinkKey"

#   count          = length(var.public_subnets_cidr)
#   subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)

#   vpc_security_group_ids      = [aws_security_group.default.id]
#   associate_public_ip_address = true

#   # user_data = <<-EOF
#   # #!/bin/bash -ex
#   # sudo apt update -y 
#   # sudo apt install nginx -y
#   # echo "<h1>EM DEP LAM</h1>" >> /usr/share/nginx/html/index.html 
#   # systemctl enable nginx
#   # systemctl start nginx
#   # EOF

#   user_data = <<-EOF
#                 #!/bin/bash
#                 sudo apt update -y
#                 sudo apt install apache2 -y
#                 sudo systemctl start apache2
#                 sudo bash -c 'echo your very first web server > /var/www/html/index.html'
#                 EOF

#   tags = {
#     "Name" : "Pink_WebPublic ${count.index}"
#   }
# }

# resource "aws_lb" "test" {
#   name               = "test-lb-tf"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.default.id]
#   subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]

#   enable_deletion_protection = false

#   # access_logs {
#   #   bucket  = aws_s3_bucket.lb_logs.bucket
#   #   prefix  = "test-lb"
#   #   enabled = true
#   # }

#   tags = {
#     Environment = "${var.environment}"
#   }
# }

# ################ Load Balance ################
# resource "aws_alb" "alb" {
#   name               = "${var.environment}-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = aws_security_group.default.*.id
#   subnets            = [aws_subnet.public_subnet[0].id,aws_subnet.public_subnet[1].id]
#   enable_deletion_protection = false
#   tags = {
#     Name = "${var.environment}-alb"
#   }
# }
# ################ Load Balance Target group ################
# resource "aws_alb_target_group" "alb_webserver" {
#   name     = "${var.environment}-alb-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id
#   stickiness {
#     type = "lb_cookie"
#   }
# }
# ################ Load Balance Listener_HTTP ################
# resource "aws_alb_listener" "alb_listener" {
#   load_balancer_arn = aws_alb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#         type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "ERROR IS HAPPINESS"
#       status_code  = "503"
#     }

#   }
# }

# ################ Load Balance Rule ################
# resource "aws_alb_listener_rule" "rule1" {
# listener_arn = aws_alb_listener.alb_listener.arn
#   action {
#     type="forward"
#     target_group_arn = aws_alb_target_group.alb_webserver.arn
#   }
#   condition {
#     host_header {
#       values = ["tps.com"]
#     }
#   }
# }
# resource "aws_alb_listener_rule" "rule2" {
# listener_arn = aws_alb_listener.alb_listener.arn

#   action {
#     type="forward"
#     target_group_arn = aws_alb_target_group.alb_webserver.arn
#   }
#   condition {
#     host_header {
#       values = ["tps.vn"]
#     }
#   }
# }


