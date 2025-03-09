
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amazn2-ami-hvm-*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_launch_template" "ecs_template" {
  name_prefix            = "ecs-template"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecs_security_group.id]

  iam_instance_profile {
    name = var.iam_instance_role
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("${path.module}/init.sh")
}

resource "aws_autoscaling_group" "ecs_auto_scaling_group" {
  name                      = "ecs-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = aws_subnet.subnets[*].id

  launch_template {
    id      = aws_launch_template.ecs_template.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "example-cluster"
}

resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "ecs-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_auto_scaling_group.arn

    managed_scaling {
      status                    = "ENABLED"
      maximum_scaling_step_size = 100
      minimum_scaling_step_size = 1
      target_capacity           = 3
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family       = "example-task"
  network_mode = "awsvpc"
  cpu          = "256"
  memory       = "512"

  execution_role_arn = "arn:aws:iam::532199187081:role/ecsTaskExecutionRole"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "example-container"
      image     = "registry.gitlab.com/your-namespace/${var.image_name}"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80,
          hostPort      = 80,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2
  launch_type     = "EC2"

  network_configuration {
    subnets          = aws_subnet.subnets[*].id
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }

  force_new_deployment = true

  triggers = {

    redeployment = timestamp()

  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "example-container"
    container_port   = 80
  }

  depends_on = [aws_autoscaling_group.ecs_auto_scaling_group]
}
