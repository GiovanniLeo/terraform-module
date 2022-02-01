variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "instance_ami" {
  type = string
  default = "ami-02c80cf04a871f641"
}

variable "owner" {
  type = string
}

variable "owner_no_email" {
  type = string
}


variable "private_subnet_1_id" {
  type = string
}

variable "private_subnet_2_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}
variable "webserver_sg" {
  type = string
}
