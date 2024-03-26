terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

variable "aws_region" {
  type        = string
  description = "e.g. us-east-2"
  default     = "us-east-2"
}

variable "php_slim_image" {
  type        = string
  description = "The php-slim ECR container URI"
}

provider "aws" {
  region = var.aws_region
}

# I am not creating the IAM role because I don't want to give the AWS client that kind of power.
# See README.md to see permissions for this role.
data "aws_iam_role" "php_slim_ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_vpc" "vpc" {
  # TODO do not hardcode
  id = "_____"
}

data "aws_subnet" "subnet" {
  # TODO do not hardcode
  id = "_____"
}

resource "aws_security_group" "php_slim_security_group" {
  name        = "php-slim-sg"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Security group for PHP slim application"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    app = "php-slim"
  }
}

# See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
resource "aws_ecs_task_definition" "php_slim_task_definition" {
  family                   = "php-slim-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 2048

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name              = "php-slim-container"
      image             = var.php_slim_image
      cpu               = 0
      memoryReservation = 2048
      essential         = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group" : "true",
          "awslogs-group" : "/ecs/php-slim-task-definition",
          "awslogs-region" : var.aws_region,
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])

  execution_role_arn = data.aws_iam_role.php_slim_ecs_task_execution_role.arn
}

resource "aws_ecs_service" "php_slim_service" {
  name            = "php-slim-service"
  cluster         = "php-slim"
  task_definition = aws_ecs_task_definition.php_slim_task_definition.arn

  launch_type      = "FARGATE"
  platform_version = "LATEST"

  desired_count = 1

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = [data.aws_subnet.subnet.id]
    security_groups  = [aws_security_group.php_slim_security_group.id]
    assign_public_ip = true
  }

  tags = {
    app = "php-slim"
  }
}
