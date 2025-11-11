resource "aws_ecr_repository" "app" {
  name = "yam-ecs-fargate"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
  tags = { Name = "yam-ecr" }
}
