resource "aws_kms_key" "eks" {
  description = "EKS Secret Encryption Key"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true
  enable_irsa                    = true
  vpc_id                         = var.vpc_id

  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }

  subnet_ids = var.cluster_subnet_ids

  cluster_addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent = true
    }

    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type       = var.ami_type
    instance_types = var.instance_types
  }

  eks_managed_node_groups = {
    private = {
      name         = "private-ng"
      subnets      = var.private_subnets
      min_size     = var.private_ng_min_size
      max_size     = var.private_ng_max_size
      desired_size = var.private_ng_desired_size
    }
    public = {
      name         = "public-ng"
      subnets      = var.public_subnets
      min_size     = var.public_ng_min_size
      max_size     = var.public_ng_max_size
      desired_size = var.public_ng_desired_size
    }
  }

  tags = merge(
    {
      "kubernetes.io/cluster/lf-aline-eks" = "shared"
    },
    var.tags
  )
}