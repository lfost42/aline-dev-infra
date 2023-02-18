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
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_db_instance" "rds" {
  identifier                  = "aline-${var.infra_env}-mysql"
  allocated_storage           = var.db_allocated_storage
  db_name                     = var.db_name
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  username                    = var.db_username
  password                    = var.db_password

  vpc_security_group_ids      = [aws_security_group.rds-sg.id]
  db_subnet_group_name        = data.aws_db_subnet_group.rds-private-subnet.name

  # multi_az                    = true
  # allow_major_version_upgrade = false
  # auto_minor_version_upgrade  = false
  deletion_protection         = false
  skip_final_snapshot         = true

  # backup_retention_period     = 35
  # backup_window               = "22:00-23:00"
  # maintenance_window          = "Sat:00:00-Sat:03:00"

  tags = merge(
    {
      Type = "rds-mysql"
    },
    var.tags
  )
}

