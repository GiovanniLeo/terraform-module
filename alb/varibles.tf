variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_profile" {
  type    = string
  default = "storm-lab"
}

variable "owner" {
  type = string
  default = "gi.leo@reply.it"
}

variable "owner_no_email" {
  type = string
  default = "gi-leo"
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_1_id" {
  type = string
}

variable "public_subnet_2_id" {
  type = string
}

variable "web_server_sg" {
  type = string
}