provider "aws" {
  version = "~> 2.0"
  region  = var.vpc_region 
}

data "template_file" "setup-pdb" {
  template = file("./scripts/setup-pdb.sh")
  vars = {
    # Any variables to be passed in shell script
  }
}

data "template_file" "setup-grafana" {
  template = file("./scripts/setup-grafana.sh")
  # vars = {
  #   # Any variables to be passed in shell script
  #   GRAFANA_URL="http://localhost:3000"
  #   COOKIEJAR="/tmp/grafana_session_$$"
  # }
}

data "template_file" "setup-nodeexporter" {
  template = file("./scripts/setup-nodeexporter.sh")
  vars = {
    # Any variables to be passed in shell script
    node_exporter_version = "0.18.1"
  }
}

data "template_cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  # get user_data --> Prometheus
  part {
    filename     = "prometheus.cfg"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.setup-pdb.rendered}"
  }

  # get user_data --> Grafana
  part {
    filename     = "grafana.cfg"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.setup-grafana.rendered}"
  }

   # get user_data --> Node Exporter
  part {
    filename     = "nodeexporter.cfg"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.setup-nodeexporter.rendered}"
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

  vpc_security_group_ids  = [module.prometheus_sg.this_security_group_id]
  subnet_id               = var.public_subnet[0]

  # set instance profile to give EC2 read only permissions
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile_api.name

  # set user data for configuring server  
  user_data               = data.template_cloudinit_config.master.rendered

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