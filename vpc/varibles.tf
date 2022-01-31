variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_profile" {
  type    = string
  default = "storm-lab"
}


variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}


variable "owner" {
  type = string
  default = "gi.leo@reply.it"
}

variable "owner_no_email" {
  type = string
  default = "gi-leo"
}



variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "instance_ami" {
  type = string
  default = "ami-02c80cf04a871f641"
}
