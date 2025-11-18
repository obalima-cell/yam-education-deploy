##############################################
# LOAD BALANCER OUTPUTS
##############################################

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app_tg.arn
}

##############################################
# ECS OUTPUTS
##############################################

output "ecs_cluster_name" {
  description = "Name of the ECS Cluster"
  value       = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  description = "Name of the ECS Service"
  value       = aws_ecs_service.svc.name
}

##############################################
# ECR OUTPUT (STATIC)
##############################################

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = "411902770159.dkr.ecr.us-east-1.amazonaws.com/yam-repo"
}

