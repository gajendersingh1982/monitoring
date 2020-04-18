module "openapi_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "openapi-sg"
  description = "Security group for Open API Servers"
  vpc_id      = var.vpc_id

 #Essential
  tags        = "${var.tags}" #Use common_vars.tf file for tags.Refer Note Below.
  egress_with_cidr_blocks = [{
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    description = ""
    cidr_blocks = "0.0.0.0/0"
  }
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      description = "Pvt subnet is open to all private IPs"
      cidr_blocks = var.vpc_cidr
    },
  ]
}