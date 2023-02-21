module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.16.0"

  name = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id = data.aws_vpc.vpc.id
  subnets = [
    for subnet in data.aws_subnet.public : subnet.id
  ]
  security_groups = [module.loadbalancer_sg.this_security_group_id]
  # Listeners
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0 # App1 TG associated to this listener
    }
  ]  
  # Target Groups
  target_groups = [
    {
      name_prefix          = "api"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        # 
        path                = "/api/alinefinancial.com"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # Application Target Group - Targets
      targets = {
        app_vm1 = {
          target_id = module.ec2_private.id[0]
          port      = 80
        },
        app_vm2 = {
          target_id = module.ec2_private.id[1]
          port      = 80
        }
      }
      tags = merge(
        {
          Name        = "lf-aline-${var.infra_env}-target-group"
        },
        var.tags
      )
    }  
  ]
      tags = merge(
        {
          Name        = "lf-aline-${var.infra_env}-alb"
        },
        var.tags
      )
}

resource "aws_security_group" "loadbalancer_sg" {
  name = "loadbalancer-sg"
  description = "Security Group with HTTP open for entire Internet (IPv4 CIDR), egress ports are all world open"
  vpc_id = data.aws_vpc.vpc.id
  # Ingress Rules & CIDR Blocks
  ingress_rules = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags = local.common_tags

  # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
  ingress_with_cidr_blocks = [
    {
      from_port   = 81
      to_port     = 81
      protocol    = 6
      description = "Allow Port 81 from internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}