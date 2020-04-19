module "prometheus_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "pdb-sg"
  description = "Security group for prometheus"
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

  ingress_cidr_blocks      = [var.vpc_cidr]
  ingress_rules            = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      description = "PDB port"
      cidr_blocks = var.myip
    },
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "Grafana port"
      cidr_blocks = var.myip
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = var.myip
    },
  ]
}