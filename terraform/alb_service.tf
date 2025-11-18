###############################################
# ECS SERVICE + Load Balancer integration
###############################################

resource "aws_ecs_service" "svc" {
  name            = "yam-education-svc"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "app"
    container_port   = 8000
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }
}
