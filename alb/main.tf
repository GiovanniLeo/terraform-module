terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}



resource "aws_security_group" "alb_sg" {
  name        = "AlbSecurityGroup"
  description = "Alb network traffic"
  vpc_id      =  var.vpc_id

  ingress {
    description = "80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.web_server_sg]
  }

  tags = {
    Name = "Security group for ALB - ${var.owner}"
  }
}

resource "aws_lb" "lb_for_auto_scaling_group" {
  name               = "ALBForAutoscaling-${var.owner_no_email}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  tags = {
    Name = "ALB - ${var.owner}"
  }
}

resource "aws_alb_target_group" "lb_target_group" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Name = "Target group - ${var.owner}"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.lb_for_auto_scaling_group.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.lb_target_group.arn
  }

  tags = {
    Name = "Alb listener - ${var.owner}"
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule" {
  listener_arn = aws_alb_listener.alb_listener.arn
  priority     = 99
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.lb_target_group.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }

  }

  tags = {
    Name = "Alb_listener_rule - ${var.owner}"
  }
}
