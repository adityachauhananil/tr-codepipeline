# Data Resource Terraform state
data "terraform_remote_state" "infra" {
  backend = "s3"
  config  = {
    bucket   = var.state_bucket_name
    key      = "${var.infra_state}.tfstate"
    region   = var.state_region
    profile  = var.infra_profile
  }
}

# Resource Target group.
resource "aws_lb_target_group" "fsc_target_group" {
  deregistration_delay = var.deregistration_delay
  name                 = "${local.prefix}-target-group"
  port                 = var.target_port
  protocol             = var.target_protocol
  vpc_id               = data.terraform_remote_state.infra.outputs.vpc_id
  slow_start           = 0
  tags                 = merge({ Name = "${local.prefix}-target-group" }, local.common_tags)
  target_type          = var.target_type

  health_check {
    enabled             = var.health_check_enabled
    healthy_threshold   = var.healthy_threshold
    interval            = var.interval
    matcher             = "200"
    path                = var.health_check_path
    protocol            = var.target_protocol
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
  }
  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}

# Resource Loadbalancer.
resource "aws_lb" "load_balancer" {
  name               = "${local.prefix}-load-balancer"
  load_balancer_type = "application"
//  subnets            = data.terraform_remote_state.network.outputs.public_subnet_ids
  subnets            = data.terraform_remote_state.infra.outputs.public_subnet_ids
  security_groups    = [aws_security_group.alb-sg.id]
  tags               = merge({ Name = "${local.prefix}-load-balancer" }, local.common_tags)
  depends_on         = [aws_security_group.alb-sg]
}

# Resource Listener.
resource "aws_alb_listener" "elk-alb-listener" {
  load_balancer_arn = aws_lb.load_balancer.id
  port              = var.listener_port
  protocol          = var.listener_protocol
  default_action {
    target_group_arn = aws_lb_target_group.fsc_target_group.id
    type             = "forward"
  }
}

# Resource Security Group.
resource "aws_security_group" "alb-sg" {
  name        = "${local.prefix}-alb-sg"
  description = "ELB Allowed Ports"
  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]
  tags   = merge({ Name = "${local.prefix}-alb-sg" }, local.common_tags)
  vpc_id = data.terraform_remote_state.infra.outputs.vpc_id
}