resource "aws_ecr_repository" "web" {
  name = "ecs-deploy-web"
}

resource "aws_ecr_repository" "migrate" {
  name = "ecs-deploy-migrate"
}