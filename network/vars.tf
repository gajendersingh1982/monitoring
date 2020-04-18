variable "name" {
  default = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
}

 variable "vpc_region" {
  description = "AWS VPC Region"
 }

variable "azs" {
  description = "List of azs"
}

variable "public_subnets" {
  description = "list of public subnets to be created"
}

variable "private_subnets" {
  description = "list of private subnets to be created"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
}