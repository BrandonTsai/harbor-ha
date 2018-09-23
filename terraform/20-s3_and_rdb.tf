

resource "aws_s3_bucket" "harbor-registry-bucket" {
  bucket        = "${var.harbor-registry-bucket}"
  force_destroy = true

  tags {
    Name        = "Harbor registry bucket"
    Environment = "production"
  }
}

resource "aws_db_subnet_group" "harbor-rds-subnet-group" {
  name = "harbor-rds-subnet-group"
  subnet_ids = ["${module.vpc.private_subnets}"]

  tags {
    Name = "Harbor DB subnet group"
  }
}

resource "aws_security_group" "harbor-db-sg" {
  name        = "harbor-db-sg"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "Security group for harbor rds"

  tags = {
    Name = "harbor-db-sg"
  }
}

resource "aws_security_group_rule" "harbor-node-to-rds" {
  type                     = "ingress"
  security_group_id        = "${aws_security_group.harbor-db-sg.id}"
  source_security_group_id = "${aws_security_group.harbor-ec2-sg.id}"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
}


resource "aws_db_instance" "harbor-db" {
  identifier              = "harbor-db"
  allocated_storage       = "${var.db_storage_size}"
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "9.6.6"
  instance_class          = "${var.db_instance_class}"
  name                    = "registry"
  username                = "${var.db_user}"
  password                = "${var.db_password}"
  parameter_group_name    = "default.postgres9.6"
  db_subnet_group_name    = "${aws_db_subnet_group.harbor-rds-subnet-group.name}"
  vpc_security_group_ids  = ["${aws_security_group.harbor-db-sg.id}"]
  skip_final_snapshot     = "true"
  backup_retention_period = "${var.db_backup_period}"
  backup_window           = "04:00-05:00"

  storage_encrypted       = "true"
  multi_az                = "true"

  tags = {
    Name        = "harbor-db"
    Environment = "Production"
  }
}