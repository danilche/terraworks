variable "vpc_name" {
  type = string
  description = "Name of the VPC"
}

variable "cidr" {
  type    = string
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type    = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnets" {
  type    = list
  description = "List of private subnet CIDR blocks"
}

variable "azs" {
  type    = list
  description = "List of availability zones"
}
