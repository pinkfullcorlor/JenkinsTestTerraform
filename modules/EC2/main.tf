resource "aws_instance" "web_public_instance" {
  ami           = "ami-04d9e855d716f9c99"
  instance_type = "t2.micro"
  key_name      = var.key_name

  count         = length(tolist(var.public_subnets_id))
  #count         = length("${jsonencode(var.public_subnets_id)}")

  #subnet_id     = "${jsonencode(var.public_subnets_id)}"
  #subnet_id = flatten([for id in var.public_subnets_id : "${id}"])
  #subnet_id = element(flatten(var.public_subnets_id), count.index)
  subnet_id = element(tolist(var.public_subnets_id), count.index)

  # for_each = [ var.public_subnet_id ]
  # subnet_id = "${each}"
  
  vpc_security_group_ids = var.security_groups_ids

  associate_public_ip_address = true

  user_data = "${file("./modules/EC2/nginxconf.sh")}"

  # user_data = <<-EOF
  #               #!/bin/bash
  #               sudo apt update -y
  #               sudo apt install nginx -y
  #               sudo systemctl start nginx
  #               EOF

  tags = {
    "Name" : "Pink_WebPublic ${count.index}"
  }
}

resource "aws_instance" "web_private_instance" {
  ami           = "ami-04d9e855d716f9c99"
  instance_type = "t2.micro"
  key_name      = var.key_name

  count          = length(var.public_subnets_cidr)

  subnet_id     = var.private_subnets_id[0].0
 
  vpc_security_group_ids = var.security_groups_ids

  associate_public_ip_address = false

  user_data = "${file("./modules/EC2/nginxconf.sh")}"

  # user_data = <<-EOF
  #               #!/bin/bash
  #               sudo apt update -y
  #               sudo apt install nginx -y
  #               sudo systemctl start nginx
                
  #               EOF

  tags = {
    "Name" : "Pink_WebPrivate ${count.index}"
  }
}

output "name" {
  value = var.list_subnet
}

#sudo bash -c 'echo your very first web server > /var/www/html/index.html'
#subnet_id = element(var.public_subnets_id, 0)
#vpc_security_group_ids      = [var.security_groups_ids]