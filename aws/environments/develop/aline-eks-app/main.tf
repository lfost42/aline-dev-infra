locals {
  account_id = data.aws_caller_identity.current.account_id
  tags = {
    Name      = "${var.cluster_name}"
    Project   = "aline"
    ManagedBy = "terraform"
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.29.1"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access  = true
  enable_irsa                     = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = module.aline_vpc.vpc_id
  subnet_ids = module.aline_vpc.public_subnets # module.aline_vpc.private_subnets

  manage_aws_auth_configmap = true

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${local.account_id}:user/eksadmin"
      username = "cluster-admin"
      groups   = ["system:masters"]
    },
  ]

  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
    }
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_groups = {
    public_node = {
      ami_type       = "BOTTLEROCKET_x86_64"
      platform       = "bottlerocket"
      min_size       = 1
      max_size       = 4
      desired_size   = 1
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      disk_size      = 10
      labels         = { 
        subnet = "public"
      }

      # this will get added to what AWS provides
      bootstrap_extra_args = <<-EOT
      # extra args added
      [settings.kernel]
      lockdown = "integrity"
      EOT
    }
  }

  depends_on = [
    module.aline_vpc
  ]

}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_iam_role_arn" {
  value = module.eks.cluster_iam_role_arn
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  value = module.eks.cluster_id
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes cluster version"
  default     = "1.23"
}

variable "aws_image_repository" {
  type        = string
  description = "AWS image repository for us-east-1 region" ## https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  default     = "052911266688.dkr.ecr.us-west-1.amazonaws.com"
}