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

variable "image_tag" {
  description = "Tag de l'image Docker (ex: v1, v2, latest)"
  type        = string
  default     = "v3"
}
