variable "cidr_block" {
  type    = string
}

variable "availability_zones" {
  type    = list(string)
}

variable "owner" {
  type = string
}

variable "owner_no_email" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "instance_ami" {
  type = string
  default = "ami-02c80cf04a871f641"
}
