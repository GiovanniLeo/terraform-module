

################ Start vpc Set-Up #######################

module "vpc" {
  source = "../vpc"

  cidr_block = var.cidr_block
  availability_zones = var.availability_zones
  owner = var.owner
  owner_no_email = var.owner_no_email

}

######################### End Vpc Set Up ########################################


resource "aws_security_group" "webserver_sg" {
  name        = "WebserverSecurityGroup"
  description = "Webserver network traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "80 from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    #Cidr of public subnet
    cidr_blocks = [
      cidrsubnet(var.cidr_block, 8, 1),
      cidrsubnet(var.cidr_block, 8, 2)
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security group for ${module.vpc.vpc_id} - ${var.owner}"
  }
}

########################################## Stiing up ALB ###################################
module "alb" {
  source = "../alb"

  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  vpc_id             = module.vpc.vpc_id
  web_server_sg      = aws_security_group.webserver_sg.id
  owner = var.owner
  owner_no_email = var.owner_no_email
}

########################## Setting up autoscaling group ##############################

module "auto_scaling" {
  source = "../auto_scaling"

  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  target_group_arn    = module.alb.target_group_arn
  webserver_sg        = aws_security_group.webserver_sg.id
  owner = var.owner
  owner_no_email = var.owner_no_email
}




