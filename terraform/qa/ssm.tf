resource "aws_ssm_parameter" "db_root_pass" {
  name  = "/${terraform.workspace}/db_root_pass"
  type  = "SecureString"
  value = random_password.root_pass.result
}

resource "aws_ssm_parameter" "app_db_user_pass" {
  name  = "/${terraform.workspace}/app_db_user_pass"
  type  = "SecureString"
  value = random_password.app_pass.result
}

resource "aws_ssm_parameter" "migrate_db_user_pass" {
  name  = "/${terraform.workspace}/migrate_db_user_pass"
  type  = "SecureString"
  value = random_password.migration_pass.result
}