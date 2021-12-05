resource "random_password" "root_pass" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "random_password" "app_pass" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "random_password" "migration_pass" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "aws_db_subnet_group" "subnets" {
  name       = "${local.prefix}-subnets"
  subnet_ids = data.terraform_remote_state.common.outputs.public_subnets
}

resource "aws_rds_cluster" "cluster" {
  cluster_identifier   = "${local.prefix}-cluster"
  engine_mode          = "serverless"
  engine               = "aurora-mysql"
  engine_version       = "5.7"
  database_name        = "knights"
  master_username      = "root"
  master_password      = random_password.root_pass.result
  db_subnet_group_name = aws_db_subnet_group.subnets.name
  skip_final_snapshot  = true
  vpc_security_group_ids = [
    aws_security_group.db.id,
  ]

  scaling_configuration {
    auto_pause               = true
    seconds_until_auto_pause = 300
    max_capacity             = 8
    min_capacity             = 1
    timeout_action           = "ForceApplyCapacityChange"
  }

  depends_on = [
    aws_cloudwatch_log_group.aurora_error,
  ]
}

resource "mysql_user" "app" {
  user               = "app"
  host               = "%"
  plaintext_password = random_password.app_pass.result
}

resource "mysql_grant" "app" {
  user     = mysql_user.app.user
  host     = mysql_user.app.host
  database = aws_rds_cluster.cluster.database_name
  privileges = [
    "SELECT",
    "INSERT",
  ]
}

resource "mysql_user" "migration" {
  user               = "migration"
  host               = "%"
  plaintext_password = random_password.migration_pass.result
}

resource "mysql_grant" "migration" {
  user     = mysql_user.migration.user
  host     = mysql_user.migration.host
  database = aws_rds_cluster.cluster.database_name
  privileges = [
    "ALL",
  ]
}

resource "aws_cloudwatch_log_group" "aurora_error" {
  name              = "/aws/rds/cluster/${local.prefix}-cluster/error"
  retention_in_days = 7
}