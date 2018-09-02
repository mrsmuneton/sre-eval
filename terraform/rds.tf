resource "aws_rds_cluster" "rds-aurora" {
  cluster_identifier      = "user-image"
  engine                  = "aurora-mysql"
  availability_zones      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  database_name           = "mydb"
  master_username         = "rdsadminuser"
  master_password         = "62uTdlJey9bYmxnSk9Q"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  tags {
    Name = "rds"
  }
}
