data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "elb_sg" {
  vpc_id = var.vpc

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      description = "HTTP"
      cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
 
 tags = {
    Name = "taylor-tf-sg"
  } 
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix          = "taylor-ecs-"
  image_id             = data.aws_ami.amazonlinux.id
  instance_type        = "t3.medium"
  user_data            = templatefile("./modules/autoscaling/userdata.sh", { clustername = var.ecs_name })
  security_groups      = [aws_security_group.elb_sg.id]
  key_name             = "taylor2"
  iam_instance_profile = var.instance_role

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "taylor-ecs-asg-example"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = var.min
  max_size             = var.max
  desired_capacity     = var.desired
  vpc_zone_identifier  = var.subnets

  lifecycle {
    create_before_destroy = true
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_tg" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = var.target_group
}