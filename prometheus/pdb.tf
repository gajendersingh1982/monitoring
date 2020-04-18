provider "aws" {
  version = "~> 2.0"
  region  = var.vpc_region 
}

data "template_file" "setup-pdb" {
  template = file("./prometheus/files/setup-pdb.sh")
  vars = {
    # Any variables to be passed in shell script
  }
}

data "template_file" "setup-grafana" {
  template = file("./prometheus/files/setup-grafana.sh")
  vars = {
    # Any variables to be passed in shell script
  }
}

data "template_cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  # get common user_data
  part {
    filename     = "prometheus.cfg"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.setup-pdb.rendered}"
  }

  # get master user_data
  part {
    filename     = "grafana.cfg"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.setup-grafana.rendered}"
  }
}

module "prometheus" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"
  
  #essential [required for Infra Governance]
  name                    = format("%s-%s-%s-%s-pdb", var.prefix, var.region_name, var.stage, var.service)
  instance_count          = var.pdb_count

  ami                     = data.aws_ami.amazonlinux.id
  instance_type           = var.instance_type
  key_name                = var.pdb_key_name
  monitoring              = false
  user_data               = data.template_cloudinit_config.master.rendered
  #user_data              = data.template_file.setup-pdb.rendered

  vpc_security_group_ids  = [module.prometheus_sg.this_security_group_id]
  subnet_id               = var.public_subnet[0]
  tags                    = var.tags
}

#EIP for EC2
resource "aws_eip" "eip" {  
  count = var.pdb_count
  vpc = true

  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_eip_association" "eip_assoc" {
  count = var.pdb_count
  instance_id = element(module.prometheus.id[*],count.index)
  allocation_id = element(aws_eip.eip.*.id[*],count.index)
}