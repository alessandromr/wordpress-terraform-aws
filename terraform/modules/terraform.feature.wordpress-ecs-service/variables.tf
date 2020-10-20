// Required
variable "aws_region" {
}

variable "account_id" {
}

variable "prefix" {
}

variable "service_name" {
}

variable "short_service_name" {
}

variable "ecs_cluster_arn" {
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}

variable "security_groups"{
  type = list(string)
}

variable "load_balancer_listener_arn" {
  type = string
}

variable "alb_rule_priority" {
  type = list(number)
}

variable "alb_path_patterns" {
  type = list(string)
}

variable "service_health_check_path" {
  type = string
}

variable "service_health_check_matcher" {
  type    = string
  default = "200-499"
}

variable "service_health_check_timeout" {
  type    = number
  default = 5
}

variable "service_health_check_interval" {
  type    = number
  default = 30
}

variable "service_desired_count" {
  default = 1
}

variable "policies" {
  type    = list(string)
  default = []
}

variable "secrets_arns" {
  type        = list(string)
  default     = []
  description = "Generates policy for accessing secrets"
}

variable "exposed_port" {
  type = number
}

variable "retention_in_days" {
  type    = number
  default = 3
}

#nginx variables

variable "php" {
  type = object({
    image_url = string
    cpu       = number
    memory    = number
    envs      = string
    secrets   = string
  })
}

#wordpress variables

variable "nginx" {
  type = object({
    image_url = string
    cpu       = number
    memory    = number
    envs      = string
    secrets   = string
  })
}

#efs
variable "efs_id" {
  type = string
}