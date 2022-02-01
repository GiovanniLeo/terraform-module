
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${var.owner}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}


resource "aws_launch_template" "launch_template_for_webserver" {
  name                   = "LaunchTemplateForWebserver-${var.owner_no_email}"
  image_id               = var.instance_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [var.webserver_sg]
  #  user_data              = filebase64("${path.module}/ec2.userdata")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "WebServer for autoscaling - ${var.owner}"
    }
  }

}

resource "aws_autoscaling_group" "auto_scaling_group_for_webserver" {
  max_size            = 2
  min_size            = 2
  desired_capacity    = 2
  target_group_arns   = [var.target_group_arn]
  vpc_zone_identifier = [
    var.private_subnet_1_id,
    var.private_subnet_2_id,
  ]

  launch_template {
    id = aws_launch_template.launch_template_for_webserver.id
  }
  name = "AutoscalingGroup-${var.owner}"
}
