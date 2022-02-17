data "aws_iam_policy_document" "ecs_task-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_ecs_cluster" "foo" {
  name = var.ecs_name
}

resource "aws_iam_role" "ecsTaskExecution_role" {
  name               = "taylor-ecsTaskExecution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task-assume-role-policy.json
}

resource "aws_iam_role_policy" "ecsTaskExecution_policy" {
  name = "taylor-ecsTaskExecPolicy"
  role = aws_iam_role.ecsTaskExecution_role.id
  policy = file("./modules/ecs/policies/ecsTaskExecutionPolicy.json")
}

resource "aws_iam_role" "ecsInstance_role" {
  name               = "taylor-ecsInstance_role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

resource "aws_iam_role_policy" "ecspolicy" {
  name = "taylor-ecsPolicy"
  role = aws_iam_role.ecsInstance_role.id
  policy = file("./modules/ecs/policies/ecsInstancePolicy.json")
}

resource "aws_iam_instance_profile" "ecs_role" {
  name = "taylor-ecs_role"
  role = aws_iam_role.ecsInstance_role.name
}

resource "aws_ecs_task_definition" "service" {
  family = "taylor"
  network_mode = "bridge"
  requires_compatibilities = ["EC2"]
  task_role_arn = aws_iam_role.ecsTaskExecution_role.arn
  execution_role_arn = aws_iam_role.ecsTaskExecution_role.arn
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "450183644535.dkr.ecr.us-east-2.amazonaws.com/taylor:fd0c4a6db27ed1149508ecb285f18346a5859300"
      cpu       = 200
      memory    = 200
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    
  ])
}

resource "aws_ecs_service" "worker" {
  name            = "taylor-service"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count   = var.desired
  iam_role        = "arn:aws:iam::450183644535:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  load_balancer {
      target_group_arn = var.target_group
      container_name = "first"
      container_port = 80
  }
}
