variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "image_url" {
  description = "ECR image URL for ECS task"
  type        = string
}

variable "container_port" {
  description = "Port utilisé par le conteneur"
  default     = 8000
}

