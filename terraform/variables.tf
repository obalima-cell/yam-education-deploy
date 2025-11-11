variable "project_name" { default = "yam-ecs-fargate" }
variable "region" { default = "us-east-1" }
variable "container_port" { default = 8000 }
variable "desired_count" { default = 1 }
variable "cpu" { default = 256 }
variable "memory" { default = 512 }
variable "image_url" { default = "" }
