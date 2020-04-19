provider "aws" {
  version = "~> 2.0"
  region  = var.vpc_region 
}

data "template_file" "setup-nodeexporter" {
  template = file("./scripts/setup-nodeexporter.sh")
  vars = {
    # Any variables to be passed in shell script
    node_exporter_version = "0.18.1"
  }
}

module "open_api" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"
  
  #essential [required for Infra Governance]
  name                    = format("%s-%s-%s-%s-web", var.prefix, var.region_name, var.stage, var.service)
  instance_count          = var.open_api_count

  ami                     = data.aws_ami.amazonlinux.id
  instance_type           = var.instance_type
  key_name                = var.pdb_key_name
  monitoring              = false
  user_data               = data.template_file.setup-nodeexporter.rendered

  vpc_security_group_ids  = [module.openapi_sg.this_security_group_id]
  subnet_id               = var.private_subnet[0]
  tags                    = var.tags
}
