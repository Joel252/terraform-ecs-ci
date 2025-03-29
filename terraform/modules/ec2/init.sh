#!/bin/bash
sudo su -
yum update -y

# Install ECS Agent
sudo amazon-linux-extras install -y ecs

# Register ECS Cluster
mkdir -p /etc/ecs/
echo "ECS_CLUSTER=${cluster_name}" > /etc/ecs/ecs.config

# Enable and Start ECS Agent
systemctl enable --now ecs
