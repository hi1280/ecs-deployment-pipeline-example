terraform {
  backend "s3" {
    key    = "ecs-deploy/common.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

data "aws_caller_identity" "current" {}