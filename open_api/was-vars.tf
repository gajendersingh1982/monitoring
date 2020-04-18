variable "prefix" {
  default = "tf"
}

variable "region_name" {
  default = "tokyo"
}

variable "service" {
  default = "galaxy-badge"
}

variable "stage" {
  default = "dev"
}
 variable "vpc_region" {
  description = "AWS VPC Region"
  default = "us-east-1"
 }

variable "vpc_id" {
  description = "VPC ID is must"
}
 variable "public_subnet" {
  description = "Public Subnet"
 }

variable "private_subnet" {
  description = "Private subnet"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
  default     = "tf-ec2"
}

variable "open_api_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 2
}


variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default = "t2.micro"
}

variable "pdb_key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = "aws_us-east-1_gb_prometheus"
}
