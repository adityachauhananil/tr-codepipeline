############################################################################
# Common variables
############################################################################
variable "app_name" {
  description = "Name of the app as a tag prefix"
}

variable "region" {
  description = "Region in which aws resources will be created"
  default     =  "us-east-1"
}

variable "tr_environment_type" {
  description = "To populate mandatory tr:environment-type tag"
}

variable "tr_resource_owner" {
  description = "To populate mandatory tr:resource-owner tag"
}

variable "secret_store" {
  description = "Store name for core api."
}


variable "shared_account" {
  description = "Account id for shared account."
}
##############

locals {
  prefix = var.app_name
  common_tags = {
    "tr:environment-type" = var.tr_environment_type
    "tr:resource-owner"   = var.tr_resource_owner
  }
}

#######################################################################
# ECS variables
#######################################################################

variable "ecs_policy_fsc" {
  description = "ECS policy name for your ecs cluster"
  default     = "ecs_policy_fsc"
}

variable "container_prefix" {
  description = "Prefix for ecs container name"
  default     = "core-api"
}

variable "image_name_api" {
  description  = "Image name for your application."
  default      = "nginx:latest"
}

variable "image_name_web" {
  description  = "Image name for your application."
  default      = "nginx:latest"
}

variable "memory" {
  description  = "Memory for container"
  default      = "512"
}

variable "cpu" {
  description  = "Memory for container"
  default      = "256"
}

#######################################################################
# Load balancer variables
#######################################################################
variable "deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds"
}

#variable "domain_name" {
#description = "Specify domain name for your acm certificate"
#}

variable "health_check_enabled" {
  description = "Indicates whether health checks are enabled"
}

variable "health_check_path" {
  description = "(Required for HTTP/HTTPS ALB) The destination for the health check request. Applies to Application Load Balancers only (HTTP/HTTPS), not Network Load Balancers (TCP)"
}

variable "healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. For lambda target groups, it needs to be greater as the timeout of the underlying lambda"
}

variable "listener_port" {
  description = "Specify a value from 1 to 65535 so that load balancer can listen to that port"
}

variable "listener_protocol" {
  description = "Specify the protocol for load balancer listener"
}

variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS"
}

variable "target_protocol" {
  description = "Target protocol so that load balancer can reach to targets with specified protocol"
}

variable "target_port" {
  description = "Target port so that load balancer can reach to targets from specified port"
}

variable "target_type" {
  description = "Target type for the load balancer target_group"
}

variable "timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check. For Application Load Balancers, the range is 2 to 120 seconds, and the default is 5 seconds for the instance target type and 30 seconds for the lambda target type. For Network Load Balancers, you cannot set a custom value, and the default is 10 seconds for TCP and HTTPS health checks and 6 seconds for HTTP health checks"
}

variable "unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy . For Network Load Balancers, this value must be the same as the healthy_threshold"
}

#######################################################################
# Autoscaling variables
#######################################################################
variable "autoscaling_min_size" {
  description = "How many ec2 instances at minimum"
}

variable "autoscaling_max_size" {
  description = "How many ec2 instances at maximum"
}

variable "autoscaling_desired_capacity" {
  description = "How many ec2 instances are desired to be running"
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "if public ip should be associated with ec2 instance"
  default     = false
}

variable "aws_instance_type" {
  description = "EC2 instance type"
}

variable "image_id" {
  description = "If you are using amazon provided ami, then please provide id"
}

variable "update_default_version" {
  description = "If terraform should also update default version of launch template when new version is created"
}

variable "instance_log_group" {
  description = "Collect the instance log_group"
}

variable "additional_user_data_script" {
  description = "Userdata script"
}

#######################################################################
# State variables
#######################################################################

variable "infra_state" {
  description = "Infra state file name."
}

variable "state_bucket_name" {
  description = "State bucket name."
}

variable "infra_profile" {
  description = "Infra profile for remote state"
}

variable "state_region" {
  description = "State bucket region"
  default     = "us-west-2"
}