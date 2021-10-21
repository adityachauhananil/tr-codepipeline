# Data resource for user_data
data "template_file" "user_data" {
  template = file("${path.module}/user_data/userdata_ecs.sh")

  vars = {
    additional_user_data_script = "${var.additional_user_data_script}"
    ecs_cluster                 = aws_ecs_cluster.ecs_cluster.name
    log_group                   = aws_cloudwatch_log_group.instance.name
  }
}

# Resource IAM role for instance.
resource "aws_iam_role" "instance_role" {
  name = "${local.prefix}-instance-role"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

  ]
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "ec2.amazonaws.com",
            "ssm.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = merge({ Name = "${local.prefix}-instance-role" }, local.common_tags)
}

# Resource IAM profile.
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${local.prefix}-instance-profile"
  role = aws_iam_role.instance_role.name
}

# Resource Security Group.
resource "aws_security_group" "autoscaling_sg" {
  name   = "${local.prefix}-autoscaling-sg"
  vpc_id = data.terraform_remote_state.infra.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "${local.prefix}-autoscaling-sg" }, local.common_tags)
}

resource "aws_security_group_rule" "from_load_balancer" {
  type                     = "ingress"
  from_port                = var.target_port
  to_port                  = var.target_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.autoscaling_sg.id
  source_security_group_id = aws_security_group.alb-sg.id
}

resource "aws_cloudwatch_log_group" "instance" {
  name = "${var.instance_log_group != "" ? var.instance_log_group : format("%s-instance", var.app_name)}"
}

# Resource launch Template.
resource "aws_launch_template" "launch_template" {
  name                   = "${local.prefix}-launch-template"
  image_id               = var.image_id
  instance_type          = var.aws_instance_type
  update_default_version = var.update_default_version
  user_data              = base64encode(data.template_file.user_data.rendered)

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = [aws_security_group.autoscaling_sg.id]
    delete_on_termination       = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "volume"
    tags          = merge({ Name = "${local.prefix}-launch-template" }, local.common_tags)
  }

  tags = merge({ Name = "${local.prefix}-launch-template" }, local.common_tags)
}

# Resource autoscaling group.
resource "aws_autoscaling_group" "fsc" {
  name                      = "${local.prefix}-autoscaling-group"
//  vpc_zone_identifier       = data.terraform_remote_state.network.outputs.private_subnet_ids
  vpc_zone_identifier       = data.terraform_remote_state.infra.outputs.private_subnet_ids
  min_size                  = var.autoscaling_min_size
  max_size                  = var.autoscaling_max_size
  desired_capacity          = var.autoscaling_desired_capacity
  health_check_grace_period = var.health_check_grace_period

  launch_template {
    id = aws_launch_template.launch_template.id
  }

  dynamic "tag" {
    for_each = merge({ Name = "${local.prefix}-autoscaling-group" }, local.common_tags)

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.fsc.id
  depends_on = [
    aws_autoscaling_group.fsc,
    aws_lb_target_group.fsc_target_group,
    aws_lb.load_balancer
  ]
}