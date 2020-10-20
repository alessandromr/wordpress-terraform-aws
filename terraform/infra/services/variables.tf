variable "aws_region" {
  type = string
}

variable "tags" {
  type    = object({})
  default = null
}

variable "project" {
  type = string
}

variable "stack" {
  type = string
}

#dedicated variables

variable "wordpress_desired_count" {
  type = number
}
variable "services_params" {
  type = map(object({
    service_memory = number
    service_cpu    = number
    env_vars       = map(string)
  }))
}

variable "log_retention_in_days" {
  type = number
}