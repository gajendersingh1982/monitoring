locals {
  is_t_instance_type = replace(var.instance_type, "/^t(2|3|3a){1}\\..*$/", "1") == "1" ? true : false
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami              = data.aws_ami.amazonlinux.id
  instance_type    = var.instance_type
  user_data        = data.template_cloudinit_config.master.rendered
  subnet_id = length(var.network_interface) > 0 ? null : element(
    distinct(compact(concat([var.subnet_id], var.subnet_ids))),
    count.index,
  )
  key_name               = var.pdb_key_name
  monitoring             = false
  vpc_security_group_ids = [module.prometheus_sg.this_security_group_id]    #var.vpc_security_group_ids
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile_api.name

  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = length(var.private_ips) > 0 ? element(var.private_ips, count.index) : var.private_ip
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  # ebs_optimized = var.ebs_optimized

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", false)
    }
  }

  source_dest_check                    = length(var.network_interface) > 0 ? null : var.source_dest_check
  # disable_api_termination              = var.disable_api_termination
  # instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  # placement_group                      = var.placement_group
  # tenancy                              = var.tenancy

  tags = merge(
    {
      "Name" = var.instance_count > 1 || var.use_num_suffix ? format("%s-%d", var.name, count.index + 1) : var.name
    },
    var.tags,
  )

  volume_tags = merge(
    {
      "Name" = var.instance_count > 1 || var.use_num_suffix ? format("%s-%d", var.name, count.index + 1) : var.name
    },
    var.volume_tags,
  )

  credit_specification {
    cpu_credits = local.is_t_instance_type ? var.cpu_credits : null
  }

  provisioner "file" {
    source      = "./scripts/configure_grafana"
    destination = "/tmp"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    
    private_key = file("./prometheus/key")
    password = ""
    host = element(aws_eip.eip1.*.public_ip[*],count.index)
    # length(var.private_ips) > 0 ? element(var.private_ips, count.index) : var.private_ip
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/configure_grafana/grafana-lib.sh",
  #     "chmod +x /tmp/configure_grafana/grafana-prometheus-wiring.sh",
  #     "/tmp/configure_grafana/grafana-prometheus-wiring.sh",
  #   ]
  # }
}

#EIP for EC2
resource "aws_eip" "eip1" {  
  count = var.instance_count
  vpc = true
}

resource "aws_eip_association" "eip_assoc1" {
  count = var.instance_count
  instance_id = element(aws_instance.this[*].id,count.index)
  allocation_id = element(aws_eip.eip1.*.id[*],count.index)
}