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
