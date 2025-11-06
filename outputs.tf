output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "Public ALB endpoint to open in browser"
}

output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "log_group" {
  value = aws_cloudwatch_log_group.app.name
}
