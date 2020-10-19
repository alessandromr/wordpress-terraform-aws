variable "tags" {
  type    = object({})
  default = null
}

variable "project" {
  type    = string
}

variable "stack" {
  type    = string
}

#dedicated variables

variable "services_params" {
  type = map(object({
    min_count             = number
    max_count             = number
    scaleup_step_size     = number
    scaleup_cooldown      = number
    scaledown_cooldown    = number
    desidered_count       = number
    service_memory        = number
    service_cpu           = number
    image                 = string
    env_vars              = map(string)
  }))
}

variable "log_retention_in_days"{
  type = number
}