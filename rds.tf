# parameter group
resource "aws_db_parameter_group" "parameter" {
  name   = "${var.project-name}-parameter"
  family = "mysql5.7"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# option group
resource "aws_db_option_group" "option" {
  name                 = "${var.project-name}-option"
  engine_name          = "mysql"
  major_engine_version = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }
}

# subnet group
resource "aws_db_subnet_group" "private" {
  name       = "${var.project-name}-subnet-group"
  subnet_ids = [aws_subnet.private-a.id, aws_subnet.private-c.id]
}

# db instance
resource "aws_db_instance" "private-db" {
  identifier                 = "${var.project-name}-private-db"
  engine                     = "mysql"
  engine_version             = "5.7.23"
  instance_class             = "db.t3.small"
  allocated_storage          = 20
  storage_type               = "gp2"
  storage_encrypted          = true
  kms_key_id                 = aws_kms_key.example.arn
  username                   = "admin"
  password                   = var.rds-db-password
  multi_az                   = true
  publicly_accessible        = false
  backup_window              = "09:10-09:40"
  backup_retention_period    = 30
  maintenance_window         = "mon:10:10-mon:10:40"
  auto_minor_version_upgrade = false
  deletion_protection        = true
  skip_final_snapshot        = false
  port                       = 3306
  apply_immediately          = false
  vpc_security_group_ids     = [module.rds_sg.security_group_id]
  parameter_group_name       = aws_db_parameter_group.parameter.name
  option_group_name          = aws_db_option_group.option.name
  db_subnet_group_name       = aws_db_subnet_group.private.name

  tags = {
    Name = "${var.project-name}-private-db"
  }

  lifecycle {
    ignore_changes = [password]
  }
}
