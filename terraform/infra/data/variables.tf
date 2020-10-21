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


variable "redis_node_type" {
  type = string
}

variable "redis_replicas_per_node" {
  type = number
  description = "Number of replicas each node has"
}

variable "redis_node_number" {
  type = number
}

variable "rds_instance_type" {
  type = string
}

variable "rds_connections_to_scale" {
  type = number
}

variable "rds_max_replicas" {
  type = number
}

variable "rds_min_replicas" {
  type = number
}

