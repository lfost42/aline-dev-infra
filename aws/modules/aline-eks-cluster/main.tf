# ===== DEPENDENCIES =====
data "aws_vpc" "this" {
    tags = {
    Name                                                      = "lf-aline-${var.infra_env}-vpc",
    "kubernetes.io/cluster/lf-aline-${var.infra_env}-cluster" = "shared"
    type = "main"
  }
}

data "aws_subnet" "public" {
  tags = {
    Name                                                      = "lf-aline-${var.infra_env}-public-sg"
    "kubernetes.io/cluster/lf-aline-${var.infra_env}-cluster" = "shared"
    "kubernetes.io/role/elb"                                  = 1
  }
}

data "aws_subnet" "private" {
  tags = {
    Name                                                      = "lf-aline-${var.infra_env}-private-sg"
    "kubernetes.io/cluster/lf-aline-${var.infra_env}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                         = 1
  }
}

data "aws_subnet" "database" {
  tags = {
    Name                                                      = "lf-aline-${var.infra_env}-database-sg"
    "kubernetes.io/cluster/lf-aline-${var.infra_env}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                         = 1
  }
}

# Security group for data plane
resource "aws_security_group" "data_plane_sg" {
  name   =  "lf-aline-${var.infra_env}-Worker-sg"
  vpc_id = data.aws_vpc.this.id

    tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-worker-sg"
    },
    var.tags
  )
}

# output "vpc_database_subnets" {
#   value = {
#     for subnet in data.aws_subnet.database :
#     subnet.id => subnet.cidr_block
#   }
# }

# Security group traffic rules
resource "aws_security_group_rule" "nodes" {
  description       = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [data.aws_subnet.public.cidr_block, data.aws_subnet.private.cidr_block, data.aws_subnet.database.cidr_block]
}

resource "aws_security_group_rule" "nodes_inbound" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  ##### private and database cidr blocks only #####
  cidr_blocks       = [data.aws_subnet.private.cidr_block, data.aws_subnet.database.cidr_block]
}

resource "aws_security_group_rule" "node_outbound" {
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Security group for control plane
resource "aws_security_group" "control_plane_sg" {
  name   = "lf-aline-${var.infra_env}-ControlPlane-sg"
  vpc_id = data.aws_vpc.this.id

    tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-ControlPlane-sg"
    },
    var.tags
  )
}

# Security group traffic rules
resource "aws_security_group_rule" "control_plane_inbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  ##### private plus public plus database #####
  cidr_blocks       = [data.aws_subnet.public.cidr_block, data.aws_subnet.private.cidr_block, data.aws_subnet.database.cidr_block]
}

resource "aws_security_group_rule" "control_plane_outbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ====== EKS CLUSTER =====
# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "lf-aline-${var.infra_env}-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = "1.21"

  vpc_config {
    ##### private subnets #####
    subnet_ids              = [[for subnet in data.aws_subnet.database : subnet.id], [for subnet in data.aws_subnet.public : subnet.id]]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

    tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-eks-cluster"
    },
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

# EKS Cluster IAM Role
resource "aws_iam_role" "cluster" {
  name = "lf-aline-${var.infra_env}-Cluster-Role"

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
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "lf-aline-${var.infra_env}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.this.id

    tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-cluster-sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

# EKS Node Groups
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.project
  node_role_arn   = aws_iam_role.node.arn
  ##### private subnet id's #####
  subnet_ids      = [for subnet in data.aws_subnet.database : subnet.id]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  ami_type       = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
  capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
  disk_size      = 20
  instance_types = ["t2.medium"]

  tags = merge(
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}

# EKS Node IAM Role
resource "aws_iam_role" "node" {
  name = "lf-aline-${var.infra_env}-Worker-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}


# ===== EKS Node Security Group =====
resource "aws_security_group" "eks_nodes" {
  name        = "lf-aline-${var.infra_env}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = data.aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                           = "lf-aline-${var.infra_env}-node-sg"
    "kubernetes.io/cluster/lf-aline-${var.infra_env}-cluster" = "owned"
  }
}

resource "aws_security_group_rule" "nodes_internal" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_cluster_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}


# ===== VARIABLES =====
variable "infra_env" {
  type        = string
  description = "infrastructure environment"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/19"
}

variable "cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    Project     = "lf-aline"
    Environment = "develop"
    ManagedBy   = "terraform"
  }
}

# ===== OUTPUTS =====
output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

