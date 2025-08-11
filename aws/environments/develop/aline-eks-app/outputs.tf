output "vpc_out" {
  description = "The AWS VPC ID"
  value       = module.vpc.vpc_out
}

output "pubsub_out" {
  description = "The AWS public subnet"
  value       = module.vpc.pubsub_out
}

output "pubsubnet_out" {
  description = "The AWS public subnet"
  value       = module.vpc.pubsubnet_out
  sensitive   = true
}

output "privsub_out" {
  description = "The AWS private subnet"
  value       = module.vpc.privsub_out
}

output "nateip_out" {
  description = "The AWS NAT elastic IP"
  value       = module.routes.nateip_out
}

output "pubsg_out" {
  description = "The AWS public security group ID"
  value       = module.sg.pubsg_out
}

output "sshsg_out" {
  description = "The AWS ssh security group ID"
  value       = module.sg.sshsg_out
}

output "bastionid_out" {
  description = "The AWS bastion host ID"
  value       = module.bastion.bastionid_out
}

output "bastionip_out" {
  description = "The AWS bastion host ip"
  value       = module.bastion.bastionip_out
}

output "pubrtid_out" {
  description = "The AWS Public route table ID"
  value       = module.routes.pubrtid_out
}

output "privrtid_out" {
  description = "The AWS Private route table ID"
  value       = module.routes.privrtid_out
}

output "peer_out" {
  description = "The AWS VPC Peering Connection ID"
  value       = module.rds.peer_out
}

# For terraform output only
output "region" {
  description = "AWS region"
  value       = var.aws_region
}

/* EKS */
output "cluster_name_out" {
  description = "The EKS Cluster name"
  value       = module.eks_cluster.cluster_name_out
}

output "cluster_id_out" {
  description = "The EKS Cluster ID"
  value       = module.eks_cluster.cluster_id_out
}

output "cluster_endpoint_out" {
  description = "The EKS Cluster endpoint"
  value       = module.eks_cluster.cluster_endpoint_out
}

output "cluster_ca_certificate_out" {
  description = "The EKS Cluster CA certificate"
  value       = module.eks_cluster.cluster_ca_certificate_out
}

output "clustersg_id_out" {
  description = "The EKS Cluster security group ID"
  value       = module.eks_cluster.clustersg_id_out
}

output "nodesg_id_out" {
  description = "The EKS Node security group ID"
  value       = module.eks_node.nodesg_id_out
}