resource "random_shuffle" "subnets" {
  input        = var.subnets
  result_count = 1
}

resource "aws_instance" "ec2" {
  ami           = var.instance_ami
  instance_type = var.instance_size

  root_block_device {
    volume_size = var.instance_root_device_size
    volume_type = "gp3"
  }

  subnet_id              = random_shuffle.subnets.result[0]
  vpc_security_group_ids = var.security_groups

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-${var.infra_role}"
      Role = var.infra_role
    },
    var.tags
  )
}

resource "aws_eip" "aline_addr" {
  count = (var.create_eip) ? 1 : 0
  vpc   = true

  lifecycle {
    # prevent_destroy = true
  }

  tags = merge(
    {
      Name = "lf-aline-${var.infra_env}-web-address"
    },
    var.tags
  )
}

resource "aws_eip_association" "eip_assoc" {
  count         = (var.create_eip) ? 1 : 0
  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.aline_addr[0].id
}