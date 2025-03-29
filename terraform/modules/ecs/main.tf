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
  name = format("%s-ec2", var.name)

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
  task_role_arn            = var.task_role_name != null ? data.aws_iam_role.task[0].arn : aws_iam_role.ecs_task_role[0].arn
  execution_role_arn       = var.execution_role_name != null ? data.aws_iam_role.execution[0].arn : aws_iam_role.ecs_exec_role[0].arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = format("%s-container", var.name)
      image     = var.image
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
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

resource "aws_ecs_service" "main" {
  name            = format("%s-service", var.name)
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.id
  desired_count   = var.desired_count

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs.id]
  }

  force_new_deployment = true
  force_delete         = true

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
# Security Group
############################

resource "aws_security_group" "ecs" {
  name   = format("%s-ecs", var.name)
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow http traffic from ALB"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# Cloud Watch
############################

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.name}-tasks"
  retention_in_days = var.logs_retention
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
  count = var.task_role_name != null ? 0 : 1

  name_prefix        = "ECSTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "ecs_exec_role" {
  count = var.execution_role_name != null ? 0 : 1

  name_prefix        = "ECSExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_exec_role_policy" {
  role       = var.execution_role_name != null ? var.execution_role_name : aws_iam_role.ecs_exec_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
