############################
# EC2 Launch template
############################

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = format("%s-ecs", var.name)
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ecs_ec2.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
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

  user_data = templatefile("${path.module}/init.sh", { cluster_name = var.name })
}

############################
# Security Group
############################

resource "aws_security_group" "ecs_ec2" {
  name   = format("%s-ecs-ec2", var.name)
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow SSH traffic"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = var.security_group_ids
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

resource "aws_iam_role" "instance" {
  name_prefix        = "ECSRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  description        = "Allows EC2 instances to call AWS services on your behalf."
}

resource "aws_iam_role_policy_attachment" "instance" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.instance.name
}
