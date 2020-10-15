#defaults
variable "aws_region" {
  type = string
}
variable "aws_account_id" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type    = object({})
  default = null
}

#customs

//CIDRS
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["a", "b"]
  description = "Availability Zones must containe a list of string like [\"a\", \"b\"]. This parameter must be longer than public_subnets_cidr and private_subnets_cidr"
}
variable "public_subnets_cidr" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20"]
}
variable "private_subnets_cidr" {
  type    = list(string)
  default = ["10.0.32.0/20", "10.0.48.0/20"]
}

//Nat Gateway
variable "include_nat_gateway" {
  type    = string
  default = false
}

//Route53 Zone
variable "include_route53_zone_association" {
  type    = string
  default = "false"
}
variable "private_zone_id" {
  type    = string
  default = ""
}
