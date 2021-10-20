############################################################################
# Common tfvars
############################################################################
region              = "us-west-2"
app_name            = "fsc"
tr_environment_type = "DEVELOPMENT"
tr_resource_owner   = "vishnu Guntuka"
infra_state         = "infra-setup"
state_bucket_name   = "fsc-terraform-tfstate-2021"
infra_profile       = "shared"
secret_store        = "arn:aws:secretsmanager:us-west-2:193421181154:secret:staging/coreapi-M6Tjyk"
############################################################################
# Autoscaling tfvars
############################################################################
autoscaling_min_size         = 1
autoscaling_max_size         = 6
autoscaling_desired_capacity = 1
health_check_grace_period    = 300
aws_instance_type            = "t3a.medium"
associate_public_ip_address  = false
instance_log_group           = ""
additional_user_data_script  = ""
#UBUNTU IMAGE
#image_id                     = "ami-03d5c68bab01f3496"
#AMAZON LINUX2AMI
image_id                     = "ami-0d034e17dea566f28"    ## us-east-1 -> "ami-0c91ffa51c05f6c5b"     ### "ami-083ac7c7ecf9bb9b0"
update_default_version       = true

############################################################################
# Load Balancer tfvars
############################################################################
deregistration_delay = 300
#domain_name          = ""
target_protocol      = "HTTP"
target_port          = 80
target_type          = "instance"
health_check_enabled = true
health_check_path    = "/"
healthy_threshold    = 5
interval             = 30
listener_port        = 80
listener_protocol    = "HTTP"
ssl_policy           = "ELBSecurityPolicy-2016-08"
timeout              = 5
unhealthy_threshold  = 10

############################################################################
# Cross Account tfvars
############################################################################
cross-account-id        = 193421181154
cross-account-role-name = "cross-account-role-dev"

//############################################################################
//# Task definition Environment tfvars
//############################################################################
//
//APP_NAME = ""
//APP_ENV = ""
//APP_DEBUG = ""
//APP_URL = ""
//LOG_CHANNEL = ""
//BROADCAST_DRIVER = ""
//QUEUE_CONNECTION = ""
//CACHE_DRIVER = ""
//CACHE_DEFAULT_TIME = ""
//SESSION_DRIVER = ""
//SESSION_LIFETIME = ""
//DB_CONNECTION = ""
//DB_HOST = ""
//DB_PORT = ""
//DB_DATABASE = ""
//DB_USERNAME = ""
//DB_PASSWORD = ""
//MAIL_MAILER = ""
//MAIL_HOST = ""
//MAIL_PORT = ""
//MAIL_USERNAME = ""
//MAIL_PASSWORD = ""
//MAIL_ENCRYPTION = ""
//MAIL_FROM_ADDRESS = ""
//MAIL_FROM_NAME = ""
