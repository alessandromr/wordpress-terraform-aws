output "vpc_id" {
  value = module.basic_infra.vpc_id
}
output "azs" {
  value = module.basic_infra.azs
}
output "public_subnets_ids" {
  value = module.basic_infra.public_subnets
}
output "private_subnets_ids" {
  value = module.basic_infra.private_subnets
}
output "database_subnets_ids" {
  value = module.basic_infra.database_subnets
}
output "database_subnets_group" {
  value = module.basic_infra.database_subnet_group
}