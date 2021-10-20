############################################################################
# Common variables
############################################################################
variable "app_name" {
  description = "Name of the app as a tag prefix"
}

variable "region" {
  description = "Region in which aws resources will be created"
}

variable "tr_environment_type" {
  description = "To populate mandatory tr:environment-type tag"
}

variable "tr_resource_owner" {
  description = "To populate mandatory tr:resource-owner tag"
}

############################################################################
# VPC variables
############################################################################
variable "availability_zones" {
  type        = list(string)
  description = "If this variable is not specified, then by default, subnets will be created in each availability zone"
  default     = ["null"]
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr block for public subnets in each az. Length of this list variable should be equal to the length of available zones"
}

variable "private_subnet_names" {
  type    = list(string)
  default = ["private-subnet-a", "private-subnet-b", "private-subnet-c"]
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "cidr block for public subnets in each az. Length of this list variable should be equal to the length of available zones"
}

variable "public_subnet_names" {
  type    = list(string)
  default = ["public-subnet-a", "public-subnet-b", "public-subnet-c"]
}

variable "public_subnet_tags" {
  description = "A map of tags to add to public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "A map of tags to add to private subnets"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
}

variable "vpc_tags" {
  description = "A map of tags to add to vpc"
  type        = map(string)
  default     = {}
}

############################################################################
# RDS variables
############################################################################
variable "database_name" {
  description = "Name of rds database"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gibibytes. If max_allocated_storage is configured, this argument represents the initial storage allocation and differences from the configuration will be ignored automatically when Storage Autoscaling occurs"
}

variable "rds_db_engine" {
  description = "The database engine to use. For supported values, see the Engine parameter in API action CreateDBInstance. Note that for Amazon Aurora instances the engine must match the DB cluster's engine'.For information on the difference between the available Aurora MySQL engines see Comparison between Aurora MySQL 1 and Aurora MySQL 2 in the Amazon RDS User Guide"
}

variable "rds_db_engine_version" {
  description = "The engine version to use. If auto_minor_version_upgrade is enabled, you can provide a prefix of the version such as 5.7 (for 5.7.10) and this attribute will ignore differences in the patch version automatically (e.g. 5.7.17). For supported values, see the EngineVersion parameter in API action CreateDBInstance. Note that for Amazon Aurora instances the engine version must match the DB cluster's engine version'"
}

variable "rds_enable_multiaz" {
  description = "Specifies if the RDS instance is multi-AZ"
}

variable "rds_instance" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
}

variable "rds_instance_class" {
  description = "The instance type of the RDS instance"
}

variable "rds_master_user" {
  description = "Username for the master DB user"
}

variable "rds_storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD)"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
}

variable "tags" {
  description = "A map of extra tags to add to rds"
  type        = map(string)
  default     = {}
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
# Load balancer variables
#######################################################################
variable "deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds"
}

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
  description = "Instance log group name"
}

variable "additional_user_data_script" {
  description = "User-data"
}

# variable "ami_name" {
#   default = "name of your ami"
# }

# variable "ami_owner" {
#   default = "owner of ami, i.e account id"
# }

# variable "ami_virtualization" {
#   default = "hvm"
# }
