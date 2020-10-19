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

variable "ecs_cluster_name" {
  type = string
}

variable "env" {
  type = string
}

variable "service_container_image_url" {
}

// Optional
variable "vpc_id" {
  type = string
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

variable "service_cpu" {
  default = 512
}

variable "service_memory" {
  default = 1024
}

variable "service_env_variables" {
  type    = string
  default = ""
}

variable "service_secrets" {
  type    = string
  default = ""
}

variable "policies" {
  type    = list(string)
  default = []
}

variable "secrets_arns" {
  type    = list(string)
  default = []
}

variable "exposed_port" {
  type = number
}

variable "retention_in_days" {
  type    = number
  default = 3
}
