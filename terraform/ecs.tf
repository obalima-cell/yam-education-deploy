resource "aws_ecs_cluster" "this" {
  name = "yam-ecs-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "yam-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

execution_role_arn = "arn:aws:iam::411902770159:role/yam-ecs-task-execution-role"
task_role_arn      = "arn:aws:iam::411902770159:role/yam-ecs-task-execution-role"

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.image_url        # ✅ Image transmise par la variable
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app" {
  name            = "yam-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "app"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.http]
}

