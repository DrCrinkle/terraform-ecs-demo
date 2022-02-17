variable "vpc_cidr" {
  type        = string
  description = "set the CIDR for your VPC here"
}

variable "ecs_name" {
  type        = string
  description = "enter the name of the ECS cluster"
}

variable "desired" {
  type        =  number
  description = "set desired capacity for auto scaling group here"
}

variable "min" {
  type        =  number
  description = "set minimum size for auto scaling group here"
}

variable "max" {
  type        =  number
  description = "set maximum size for auto scaling group here"
}