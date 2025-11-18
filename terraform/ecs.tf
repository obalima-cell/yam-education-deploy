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
      image     = var.image_url   # ✅ FIX ICI — pas de tag ajouté
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/yam-education"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

