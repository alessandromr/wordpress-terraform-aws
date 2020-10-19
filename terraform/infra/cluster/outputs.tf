#ecs
output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_wordpress.id
}
output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_wordpress.arn
}

output "ecs_instances_sg_id" {
  value = aws_security_group.ecs_instances.id
}

#alb
output "aws_alb_arn" {
  value = aws_lb.load_balancer.arn
}
output "aws_lb_listener_arn" {
  value = aws_lb_listener.default_listener.arn
}