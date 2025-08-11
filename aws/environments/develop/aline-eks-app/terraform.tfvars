cluster_name    = "my-aline-eks-cluster"
cluster_version = "1.29"



# --- EKS node variables ---
eks_node_groups = {
  public_node = {
    # ----------------------------------------
    ami_type       = "BOTTLEROCKET_x86_64"
    platform       = "bottlerocket"
    min_size       = 2
    max_size       = 6
    desired_size   = 2
    instance_types = ["t3.medium"]
    # ----------------------------------------
    capacity_type  = "SPOT"
    disk_size      = 20
    labels = {
      subnet = "public"
    }
    bootstrap_extra_args = <<-EOT
    [settings.kernel]
    lockdown = "integrity"
    EOT
  }
}