module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
}

module "ecs" {
  source       = "./modules/ecs"
  vpc_cidr     = var.vpc_cidr
  ecs_name     = var.ecs_name
  desired       = var.desired
  target_group = module.loadbalancer.target_group_arn
}

module "loadbalancer" {
  source       = "./modules/loadbalancer"
  vpc          = module.vpc.vpc_id
  subnets      = module.vpc.public_subnets
}

module "autoscaling" {
  source       = "./modules/autoscaling"
  depends_on   = [
    module.loadbalancer
  ]
  desired       = var.desired
  min           = var.min
  max           = var.max
  ecs_name      = var.ecs_name
  vpc           = module.vpc.vpc_id
  subnets       = module.vpc.private_subnets
  target_group  = module.loadbalancer.target_group_arn
  elb           = module.loadbalancer.elb
  instance_role = module.ecs.ecs_role
}
