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
      subnets      = var.private_sunbets
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
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-role"

assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
tags = var.tags
}

resource "aws_iam_role_policy_attachment"     "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role" "managed_workers" {
  name = "eks-managed-worker-node"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.managed_workers.name
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.managed_workers.name
}
resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.managed_workers.name
}
