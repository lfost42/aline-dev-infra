# module "vpc" {
#   source = "../../../modules/vpc"

#   infra_env              = var.infra_env
#   vpc_cidr               = var.aline_cidr
#   cidr_bits              = var.aline_cidr_bits
#   az_count               = var.aline_az_count
#   create_public_subnet   = var.aline_public_subnet
#   create_private_subnet  = var.aline_private_subnet
#   create_database_subnet = var.aline_database_subnet
#   vpc_type               = var.aline_vpc_type
# }

# variable "aline_az_count" {
#   type        = number
#   description = "desired number of availability zones"
#   default     = 1
# }

# variable "aline_cidr_bits" {
#   type        = number
#   description = "number of cidr bits"
#   default     = 4
# }

# variable "aline_cidr" {
#   type        = string
#   description = "project cidr subnet block"
#   default     = "10.2.0.0/18"
# }

# variable "aline_public_subnet" {
#   type        = bool
#   description = "indicates whether to include a public subnet in the VPC"
#   default     = true
# }

# variable "aline_private_subnet" {
#   type        = bool
#   description = "indicates whether to include a private subnet in the VPC"
#   default     = true
# }

# variable "aline_database_subnet" {
#   type        = bool
#   description = "indicates whether to include a database subnet in the VPC"
#   default     = true
# }

# variable "aline_vpc_type" {
#   type        = string
#   description = "type of vpc"
#   default     = "main"
# }

# output "vpc_id" {
#   value = module.vpc.vpc_id
# }
# output "vpc_cidr" {
#   value = module.vpc.vpc_cidr
# }
# output "vpc_database_subnets" {
#   value = module.vpc.vpc_database_subnets
# }
# output "vpc_database_subnet_ids" {
#   value = module.vpc.vpc_database_subnet_ids
# }
# output "vpc_database_subnet" {
#   value = module.vpc.vpc_database_subnets
# }

locals {
  account_id = data.aws_caller_identity.current.account_id
  tags = {
    Name      = "${var.cluster_name}"
    Project   = "lf-eks"
    ManagedBy = "terraform"
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.29.1"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  cluster_endpoint_private_access = true
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

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

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
    bottlerocket_nodes = {
      ami_type      = "BOTTLEROCKET_x86_64"
      platform      = "bottlerocket"
      min_size      = 1
      max_size      = 1
      desired_size  = 1
      instance_types = ["t3.micro"]
      capacity_type = "SPOT"

      # this will get added to what AWS provides
      bootstrap_extra_args = <<-EOT
      # extra args added
      [settings.kernel]
      lockdown = "integrity"
      EOT
    }
  }

}