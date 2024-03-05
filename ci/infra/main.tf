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
  region = "us-east-2"
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
      memoryReservation = 512
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

  # TODO
  execution_role_arn = "________"
}
