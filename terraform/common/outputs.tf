output "vpc_id" {
  value = aws_vpc.ecs_deploy.id
}
output "alb_sg_id" {
  value = aws_security_group.alb.id
}
output "codebuild_sg_id" {
  value = aws_security_group.codebuild.id
}
output "public_subnets" {
  value = aws_subnet.public.*.id
}
output "domain_name" {
  value = data.aws_route53_zone.domain.name
}
output "alb_listener_https_arn" {
  value = aws_lb_listener.https.arn
}
output "aws_ecr_repository_web" {
  value = aws_ecr_repository.web.repository_url
}
output "aws_ecr_repository_migrate" {
  value = aws_ecr_repository.migrate.repository_url
}