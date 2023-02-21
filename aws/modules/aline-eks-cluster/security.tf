# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster_sg" {
  name        = "lf-aline-${var.infra_env}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.vpc.id

    tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-cluster-sg"
    },
    var.tags
  )
}

# Security group for data plane
resource "aws_security_group" "worker_sg" {
  name   =  "lf-aline-${var.infra_env}-Worker-sg"
  vpc_id = data.aws_vpc.vpc.id

    tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-worker-sg"
    },
    var.tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster_sg" {
  name        = "lf-aline-${var.infra_env}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.vpc.id

    tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-cluster-sg"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "vpc_endpoint_egress" {
  security_group_id = aws_security_group.worker_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
}

resource "aws_security_group_rule" "vpc_endpoint_self_ingress" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  security_group_id        = aws_security_group.worker_sg.id
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.worker_sg.id
}

# EKS Control Plane security group
resource "aws_security_group_rule" "vpc_endpoint_eks_cluster_sg" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.worker_sg.id
  to_port                  = 443
  type                     = "ingress"
  depends_on = [aws_eks_cluster.cluster]
}