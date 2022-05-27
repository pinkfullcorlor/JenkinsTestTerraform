################ Load Balance ################
resource "aws_alb" "alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups_ids

  #count              = length(tolist(var.public_subnets_id))
  subnets         = tolist(var.public_subnets_id)


  enable_deletion_protection = false
  tags = {
    Name = "${var.environment}-alb"
  }
}
################ Load Balance Target group ################
resource "aws_alb_target_group" "alb_webserver" {
  name     = "${var.environment}-alb-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  stickiness {
    type = "lb_cookie"
  }
}
################ Load Balance Listener_HTTP ################
resource "aws_alb_listener" "alb_listener" {  
  #count              = length(tolist(var.public_subnets_id))
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
        type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "ERROR IS HAPPINESS"
      status_code  = "503"
    }

  }
}

################ Load Balance Rule ################
resource "aws_alb_listener_rule" "rule1" {
    #count              = length(tolist(var.public_subnets_id))  
listener_arn = aws_alb_listener.alb_listener.arn
  action {
    type="forward"
    target_group_arn = aws_alb_target_group.alb_webserver.arn
  }
  condition {
    host_header {
      values = ["tps.com"]
    }
  }
}
resource "aws_alb_listener_rule" "rule2" {

  #count              = length(tolist(var.public_subnets_id))      
  listener_arn = aws_alb_listener.alb_listener.arn

  action {
    type="forward"
    target_group_arn = aws_alb_target_group.alb_webserver.arn
  }
  condition {
    host_header {
      values = ["tps.vn"]
    }
  }
}