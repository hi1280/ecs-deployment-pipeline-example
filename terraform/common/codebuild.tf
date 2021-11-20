resource "aws_codebuild_project" "apply" {
  name         = "ecs-deploy-apply"
  description  = "terraform apply"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "public.ecr.aws/hashicorp/terraform:1.0.11"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = file("buildspec/qa/apply.yml")
    git_clone_depth     = 1
    insecure_ssl        = false
    report_build_status = false
    type                = "NO_SOURCE"
  }

  vpc_config {
    security_group_ids = [
      aws_security_group.codebuild.id,
    ]
    subnets = aws_subnet.private.*.id
    vpc_id  = aws_vpc.ecs_deploy.id
  }
}

resource "aws_codebuild_project" "destroy" {
  name         = "ecs-deploy-destroy"
  description  = "terraform destroy"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    encryption_disabled    = false
    override_artifact_name = false
    type                   = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "public.ecr.aws/hashicorp/terraform:1.0.11"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    type                        = "LINUX_CONTAINER"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  source {
    buildspec           = file("buildspec/qa/destroy.yml")
    git_clone_depth     = 1
    insecure_ssl        = false
    report_build_status = false
    type                = "NO_SOURCE"
  }

  vpc_config {
    security_group_ids = [
      aws_security_group.codebuild.id,
    ]
    subnets = aws_subnet.private.*.id
    vpc_id  = aws_vpc.ecs_deploy.id
  }
}

resource "aws_cloudwatch_log_group" "codebuild_apply" {
  name              = "/aws/codebuild/${aws_codebuild_project.apply.name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "codebuild_destroy" {
  name              = "/aws/codebuild/${aws_codebuild_project.destroy.name}"
  retention_in_days = 7
}