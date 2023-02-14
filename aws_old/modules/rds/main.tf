resource "aws_db_instance" "alinedb" {
    name = var.db_name
    identifier = var.db_identifier
    instance_class = var.db_instance_class
    engine = var.db_engine
    engine_version = var.db_engine_version
    username = var.db_username
    password = var.db_password
    port = var.db_port
    allocated_storage = var.db_storage
    final_snapshot_identifier = var.db_snapshot_name
    skip_final_snapshot = false
    db_subnet_group_name = aws_db_subnet_group.aline_db.name

    lifecycle {
      prevent_destroy = true
    }
}

resource "aws_db_subnet_group" "aline_db" {
  name = "aline_db"
  subnet_ids = var.db_subnets
}

resource "aws_security_group" "rds_sg" {
  name = "rds_sg"
  description = "cluster traffic to rds"
  vpc_id = var.vpc_id
  ingress = {
    cidr_blocks = [ "value" ]
    description = var.vpc_id
    from_port = 3306
    protocol = "tcp"
    security_groups = [ var.rds_sg_id ]
    self = false
    to_port = 3306
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
