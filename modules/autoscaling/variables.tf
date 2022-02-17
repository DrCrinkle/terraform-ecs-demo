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

variable "ecs_name" {
  type        = string
  description = "enter the name of the ECS cluster"
}

variable "vpc" {
  type        =  string
}

variable "subnets" {
  type        =  list(string)
}

variable "target_group" {
  type        =  string
}

variable "elb" {
  type        =  string
}

variable "instance_role" {
  type = string
}
