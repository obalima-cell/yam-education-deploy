resource "aws_ecs_cluster" "this" {
  name = "yam-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
