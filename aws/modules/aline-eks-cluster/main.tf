# EKS Cluster
resource "aws_eks_cluster" "this" {
  enabled_cluster_log_types = []
  name                      = var.cluster_name
  node_group_name           = var.node_group_name
  role_arn                  = aws_iam_role.cluster.arn
  version                   = var.eks_cluster_version

  vpc_config {
    subnet_ids              = var.cluster_subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }
  tags = var.tags

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.cluster
  ]
}

resource "aws_eks_node_group" "public_ng" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "lf-aline-${infra_env}-managed-workers"
  node_role_arn   = aws_iam_role.managed_workers.arn
  subnet_ids      = var.public_nodegroup_subnet_ids

  scaling_config {
    desired_size = var.public_ng_desired_size
    max_size     = var.public_ng_max_size
    min_size     = var.public_ng_min_size
  }

  instance_types = var.public_ng_instance_type

  labels = {
    lifecycle = "OnDemand"
  }

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = var.public_subnet_ids
  }

  release_version = var.managed_node_group_release_version

    tags = merge(
    {
      Name   = "public-ng"
      Role   = "public"
      Subnet = "public"
    },
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "private_ng" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "lf-aline-${infra_env}-managed-workers"
  node_role_arn   = aws_iam_role.managed_workers.arn
  subnet_ids      = var.private_nodegroup_subnet_ids
  scaling_config {
    desired_size = var.private_ng_desired_size
    max_size     = var.private_ng_max_size
    min_size     = var.private_ng_min_size
  }
  labels = {
    lifecycle = "OnDemand"
  }
  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = var.public_subnet_ids
  }
  release_version = "1.14.7-20190927"
  tags = merge(
    {
    Name   = "private-ng"
    Role   = "private"
    Subnet = "private"
    },
    var.tags
  )
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "cluster" {
  name              = "/aws/eks/lf-aline-${infra_env}/cluster"
  retention_in_days = 7
}

resource "aws_iam_role" "cluster" {
  name = "lf-aline-${infra_env}-cluster-role"
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
  name = "lf-aline-${infra_env}-managed-worker-node"
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
