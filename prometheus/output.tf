output "id" {
  description = "List of IDs of instances"
  value       = module.prometheus.*.id
}

output "eip_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = aws_eip.eip.*.public_ip
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = module.prometheus.*.private_ip
}

output "sg" {
  description = "List of ARNs of instances"
  value       = module.prometheus_sg.this_security_group_id
}

output "security_groups" {
  description = "List of associated security groups of instances"
  value       = module.prometheus.*.security_groups
}
