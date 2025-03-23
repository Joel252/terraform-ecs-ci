############################
# ECS Cluster
############################

resource "aws_ecs_cluster" "main" {
  name = var.name
}

############################
# Capacity Providers
############################

resource "aws_ecs_capacity_provider" "main" {
  name = format("%s-ecs-ec2", var.name)

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.auto_scaling_group_arn

    managed_scaling {
      status                    = "ENABLED"
      maximum_scaling_step_size = 100
      minimum_scaling_step_size = 1
      target_capacity           = 3
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.main.name
  }
}

############################
# Task Definition
############################

resource "aws_ecs_task_definition" "main" {
  family                   = format("%s-task", var.name)
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_exec_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsondecode([
    {
      name      = format("%s-container", var.name)
      image     = var.image
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          host_port     = var.container_port
          protocol      = "tcp"
        }
      ],

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name
          awslogs-region        = var.awslogs_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

############################
# ECS Service
############################

resource "aws_ecs_service" "ecs_service" {
  name            = format("%s-service", var.name)
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.id
  desired_count   = var.num_instances
  launch_type     = "EC2"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  force_new_deployment = true

  triggers = {
    redeployment = timestamp()
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = format("%s-container", var.name)
    container_port   = var.container_port
  }
}

############################
# Cloud Watch
############################

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.name}-task"
  retention_in_days = 7
}

resource "aws_iam_policy" "ecs_logs_policy" {
  name        = "${var.name}-logs-policy"
  description = "Allows to ECS write logs on CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "${aws_cloudwatch_log_group.ecs_log_group.arn}:*"
    }]
  })
}

############################
# IAM Role
############################

resource "aws_iam_role" "ecs_task_role" {
  name_prefix        = "demo-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role" "ecs_exec_role" {
  name_prefix        = "demo-ecs-exec-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_doc.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_policy" {
  role       = aws_iam_role.ecs_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
