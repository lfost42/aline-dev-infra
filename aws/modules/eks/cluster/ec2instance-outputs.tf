# AWS EC2 Instance Terraform Outputs

# Private EC2 Instances
## ec2_private_instance_ids
output "ec2_private_instance_ids" {
  description = "List of IDs of instances"
  value       = module.ec2_private.id
}
## ec2_private_ip
output "ec2_private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = module.ec2_private.private_ip 
}
