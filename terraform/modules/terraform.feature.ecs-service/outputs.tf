output "service_name" {
  value = aws_ecs_service.service.name
}
output "service_id" {
  value = aws_ecs_service.service.id
}
output "service_cluster_arn" {
  value = aws_ecs_service.service.cluster
}