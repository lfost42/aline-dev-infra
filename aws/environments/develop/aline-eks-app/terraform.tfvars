cluster_name    = "my-aline-eks-cluster"
cluster_version = "1.29"

public_node_group_config = {
  ami_type       = "BOTTLEROCKET_x86_64"
  platform       = "bottlerocket"
  min_size       = 2
  max_size       = 6
  desired_size   = 2
  instance_types = ["t3.small"]
}