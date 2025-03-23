############################
# EC2 Launch template
############################

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = format("%s-ecs", var.name)
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ecs.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = format("%s-instance", var.name)
    }
  }

  user_data = filebase64("${path.module}/init.sh")
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
    security_groups = var.alb_security_group != null ? [var.alb_security_group] : []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# Auto Scaling Group
############################

resource "aws_autoscaling_group" "ecs" {
  name                = format("%s-ecs", var.name)
  desired_capacity    = var.num_instances
  min_size            = var.min_instances
  max_size            = var.max_instances
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

############################
# IAM Role
############################

resource "aws_iam_role" "ecs" {
  name_prefix        = format("%s-ecs-role", var.name)
  assume_role_policy = data.aws_iam_policy_document.ecs_doc.json
  description        = "Allows EC2 instances to call AWS services on your behalf."
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs" {
  name_prefix = format("%s-profile")
  path        = "ecs/instance"
  role        = aws_iam_role.ecs.name
}
