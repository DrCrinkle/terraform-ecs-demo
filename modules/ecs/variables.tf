variable "vpc_cidr" {
  type        = string
  description = "set the CIDR for your VPC here"
}

variable "ecs_name" {
  type        = string
  description = "enter the name of the ECS cluster"
}

variable "target_group" {
  type = string
}

variable "desired" {
  type = number
}
