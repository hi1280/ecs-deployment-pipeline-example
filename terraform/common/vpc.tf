# VPC
resource "aws_vpc" "ecs_deploy" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ecs-deploy-vpc"
  }
}

locals {
  public_subnet_az = [
    "ap-northeast-1a",
    "ap-northeast-1c"
  ]
  private_subnet_az = [
    "ap-northeast-1a"
  ]
}

resource "aws_subnet" "public" {
  count                   = length(local.public_subnet_az)
  vpc_id                  = aws_vpc.ecs_deploy.id
  cidr_block              = cidrsubnet(aws_vpc.ecs_deploy.cidr_block, 8, count.index)
  availability_zone       = local.public_subnet_az[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "ecs-deploy-public-${local.public_subnet_az[count.index]}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ecs_deploy.id
}

resource "aws_route" "route" {
  route_table_id         = aws_vpc.ecs_deploy.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_eip" "ecs_deploy" {
  count = length(local.private_subnet_az)
  vpc   = true
}

resource "aws_nat_gateway" "ecs_deploy" {
  count         = length(local.private_subnet_az)
  allocation_id = aws_eip.ecs_deploy[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "ecs-deploy-ngw-${local.private_subnet_az[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count                   = length(local.private_subnet_az)
  vpc_id                  = aws_vpc.ecs_deploy.id
  cidr_block              = cidrsubnet(aws_vpc.ecs_deploy.cidr_block, 8, count.index + length(aws_subnet.public))
  availability_zone       = local.private_subnet_az[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "ecs-deploy-private-${local.private_subnet_az[count.index]}"
  }
}

resource "aws_route_table" "private" {
  count  = length(local.private_subnet_az)
  vpc_id = aws_vpc.ecs_deploy.id
  tags = {
    Name = "ecs-deploy-private-${local.private_subnet_az[count.index]}"
  }
}

resource "aws_route" "private" {
  count                  = length(local.private_subnet_az)
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.ecs_deploy[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnet_az)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

# Security Group
resource "aws_security_group" "alb" {
  name        = "ecs-deploy-alb"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.ecs_deploy.id
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = [
        "::/0",
      ]
      security_groups = []
      prefix_list_ids = []
      self            = false
      description     = "HTTP"
      protocol        = "tcp"
      from_port       = 80
      to_port         = 80
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = [
        "::/0",
      ]
      security_groups = []
      prefix_list_ids = []
      self            = false
      description     = "HTTPS"
      protocol        = "tcp"
      from_port       = 443
      to_port         = 443
    }
  ]

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "codebuild" {
  name        = "ecs-deploy-codebuild"
  description = "Security group for CodeBuild"
  vpc_id      = aws_vpc.ecs_deploy.id
  ingress     = []

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}