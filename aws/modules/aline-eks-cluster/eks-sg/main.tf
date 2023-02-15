# Security group for data plane
resource "aws_security_group" "data_plane_sg" {
  name   =  "aline-${var.dev-infra}-Worker-sg"
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "aline-${var.dev-infra}-Worker-sg"
  }
}

# Security group traffic rules
resource "aws_security_group_rule" "nodes" {
  description       = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = flatten([cidrsubnet(module.vpc.vpc_cidr, module.vpc.subnet_cidr_bits, 0), cidrsubnet(module.vpc.vpc_cidr, var.subnet_cidr_bits, 1), cidrsubnet(module.vpc.vpc_cidr, module.vpc.subnet_cidr_bits, 2), cidrsubnet(module.vpc.vpc_cidr, module.vpc.subnet_cidr_bits, 3)])
}

resource "aws_security_group_rule" "nodes_inbound" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.data_plane_sg.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = flatten([cidrsubnet(module.vpc.vpc_cidr, module.vpc.subnet_cidr_bits, 2), cidrsubnet(module.vpc.vpc_cidr, module.vpc.subnet_cidr_bits, 3)])
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
  name   = "aline-${var.dev-infra}-ControlPlane-sg"
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "aline-${var.dev-infra}-ControlPlane-sg"
  }
}

# Security group traffic rules
resource "aws_security_group_rule" "control_plane_inbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = flatten([cidrsubnet(module.vpc.vpc_cidr, vmodule.vpc.subnet_cidr_bits, 0), cidrsubnet(module.vpc.vpc_cidr, module.vpc.subnet_cidr_bits, 1), cidrsubnet(module.vpc.vpc_cidr, module.vpc.subnet_cidr_bits, 2), cidrsubnet(module.vpc.vpc_cidr, module.vpc.subnet_cidr_bits, 3)])
}

resource "aws_security_group_rule" "control_plane_outbound" {
  security_group_id = aws_security_group.control_plane_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}