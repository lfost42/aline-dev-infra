resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
  subnet_ids = slice(cidrsubnets("10.0.0.0/17", 4, 4, 4, 4, 4, 4), 4, 6)
}

resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"
  vpc_id = data.aws_vpc.vpc.id
}

# Ingress Security Port 3306
resource "aws_security_group_rule" "mysql_inbound_access" {
  from_port         = 3306
  protocol          = "tcp"
  security_group_id = aws_security_group.rds-sg.id
  to_port           = 3306
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_instance" "rds" {
  source  = "terraform-aws-modules/rds-mysql/aws"
  version = "5.4.2"
  # insert the 12 required variables here

  name                        = "aline-${var.infra_env}-mysql"
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  family                      = "mysql8.0"
  preferred_versions          = ["8.0.28", "8.0.27"]
  instance_type               = var.instance_type

  vpc_id                      = data.aws_vpc.vpc.id
  subnets                     = aws_db_subnet_group.rds-private-subnet
  replica_count               = 1
  db_parameter_group_name         = "default.mysql8.0"
  db_subnet_group_name            = aws_security_group.rds-sg

  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false
  username = var.master_username
  password = var.master_password
  backup_retention_period     = 35
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  multi_az                    = true
  skip_final_snapshot         = true

  tags = {
    Type        = "mysql"
  }
}

