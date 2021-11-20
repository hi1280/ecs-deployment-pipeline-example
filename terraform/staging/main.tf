terraform {
  backend "s3" {
    key                  = "ecs-deploy/staging.tfstate"
    region               = "ap-northeast-1"
  }

  required_providers {
    mysql = {
      source  = "winebarrel/mysql"
      version = "~> 1.10.6"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "random" {}

provider "mysql" {
  endpoint = "${aws_rds_cluster.cluster.endpoint}:3306"
  username = "root"
  password = random_password.root_pass.result
}

locals {
  prefix = "ecs-deploy-staging"
}

data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = var.tfstate_bucket
    key    = "ecs-deploy/common.tfstate"
    region = "ap-northeast-1"
  }
}