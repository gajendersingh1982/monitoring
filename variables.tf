variable "myip" {
  description = "my IP"
  default = "x.x.x.x/32"
}
variable "prefix" {
  default = "tf"
}

variable "region_name" {
  default = "virginia"
}

variable "service" {
  default = "test"
}

variable "stage" {
  default = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
  default = "10.0.0.0/20"
}
 variable "vpc_region" {
  description = "AWS VPC Region"
  default = "us-east-1"
 }

variable "azs" {
  description = "List of azs"
  default = ["us-east-1b"]
}

variable "public_subnets" {
  description = "list of public subnets to be created"
  default = ["10.0.1.0/24"]
}

variable "private_subnets" {
  description = "list of private subnets to be created"
  default = ["10.0.2.0/24"]
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  default = {
    "Owner"     = "gajender.s"
    "Service" = "test"
    "Stage"     = "dev"
    "Creator"   = "terraform"
  }
}
