# Cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project-name}-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.project-name}-task-definition"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

# Service
resource "aws_ecs_service" "service" {
  name                              = "${var.project-name}-service"
  cluster                           = aws_ecs_cluster.cluster.arn
  task_definition                   = aws_ecs_task_definition.task_definition.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  platform_version                  = "1.3.0"
  health_check_grace_period_seconds = 60

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_sg.security_group_id]

    subnets = [
      aws_subnet.private-a.id,
      aws_subnet.private-c.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web-tg.arn
    container_name   = "example"
    container_port   = 80
  }

  #   lifecycle {
  #     ignore_changes = [task_definition]
  #   }
}
