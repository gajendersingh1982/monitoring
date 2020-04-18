output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "private_subnets" {
  description = "Private subnet Ids"
  value       = module.network.private_subnets
}

output "public_subnets" {
  description = "Public subnet Ids"
  value       = module.network.public_subnets
}

output "id" {
  description = "List of IDs of instances"
  value       = module.pdb.*.id
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = module.pdb.*.private_ip
}

output "eip_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = module.pdb.*.eip_ip
}

output "sg" {
  description = "List of ARNs of instances"
  value       = module.pdb.sg
}
