resource "aws_db_subnet_group" "rds-private-subnet" {
  name = "rds-private-subnet-group"
  subnet_ids = var.database_subnets
}

resource "aws_security_group" "rds-sg" {
  name   = "my-rds-sg"
  vpc_id = var.vpc_id
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
  identifier                  = "aline-${var.infra_env}-mysql"
  allocated_storage           = 10
  db_name                     = "alinedb"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  parameter_group_name        = var.db_parameter_group_name
  instance_class              = var.db_instance_class
  username                    = var.db_username
  password                    = var.db_password

  vpc_security_group_ids      = [aws_security_group.rds-sg.id]
  db_subnet_group_name        = aws_db_subnet_group.rds-private-subnet.name

  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = false

  backup_retention_period     = 35
  deletion_protection         = false
  skip_final_snapshot         = true
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  multi_az                    = true

  tags = merge(
    {
      Type = "mysql"
    },
    var.tags
  )
}

