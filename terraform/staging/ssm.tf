resource "aws_ssm_parameter" "db_root_pass" {
  name  = "/ecs-deploy/staging/db_root_pass"
  type  = "SecureString"
  value = random_password.root_pass.result
}

resource "aws_ssm_parameter" "app_db_user_pass" {
  name  = "/ecs-deploy/staging/app_db_user_pass"
  type  = "SecureString"
  value = random_password.app_pass.result
}

resource "aws_ssm_parameter" "migrate_db_user_pass" {
  name  = "/ecs-deploy/staging/migrate_db_user_pass"
  type  = "SecureString"
  value = random_password.migration_pass.result
}