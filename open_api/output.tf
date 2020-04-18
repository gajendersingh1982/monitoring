output "id" {
  description = "List of IDs of instances"
  value       = module.open_api.*.id
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = module.open_api.*.private_ip
}

output "sg" {
  description = "List of ARNs of instances"
  value       = module.openapi_sg.this_security_group_id
}

output "security_groups" {
  description = "List of associated security groups of instances"
  value       = module.open_api.*.security_groups
}
