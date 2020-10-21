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

variable "cluster_name" {
  type = string
}
variable "cluster_min_size" {
  type    = number
  default = 1
}
variable "cluster_max_size" {
  type    = number
  default = 1
}
variable "cluster_desired_capacity" {
  type    = number
  default = 1
}
variable "instance_type" {
  type = string
}


#capacity provider

variable "minimum_scaling_step_size" {
  type = number
}
variable "maximum_scaling_step_size" {
  type = number
}
variable "capacity_provider_desired_utilization" {
  type = number
}
