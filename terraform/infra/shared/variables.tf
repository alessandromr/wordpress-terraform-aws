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

variable "enable_nat_gateway" {
  type = bool
}
variable "single_nat_gateway" {
  type = bool
}


