# data "aws_secretsmanager_secret" "APP_NAME" {
#   arn = "${var.secret_store}:APP_NAME"
# }
# data "aws_secretsmanager_secret" APP_ENV {
#   arn = "${var.secret_store}:APP_ENV"
# }
# data "aws_secretsmanager_secret" APP_DEBUG {
#   arn = "${var.secret_store}:APP_DEBUG"
# }
# data "aws_secretsmanager_secret" APP_URL {
#   arn = "${var.secret_store}:APP_URL"
# }
# data "aws_secretsmanager_secret" LOG_CHANNEL {
#   arn = "${var.secret_store}:LOG_CHANNEL"
# }
# data "aws_secretsmanager_secret"  BROADCAST_DRIVER {
#   arn = "${var.secret_store}:BROADCAST_DRIVER"
# }
# data "aws_secretsmanager_secret" QUEUE_CONNECTION {
#   arn = "${var.secret_store}:QUEUE_CONNECTION"
# }
# data "aws_secretsmanager_secret" CACHE_DRIVER {
#   arn = "${var.secret_store}:CACHE_DRIVER"
# }
# data "aws_secretsmanager_secret" CACHE_DEFAULT_TIME {
#   arn = "${var.secret_store}:CACHE_DEFAULT_TIME"
# }
# data "aws_secretsmanager_secret" SESSION_DRIVER {
#   arn = "${var.secret_store}:SESSION_DRIVER"
# }
# data "aws_secretsmanager_secret" SESSION_LIFETIME {
#   arn = "${var.secret_store}:SESSION_LIFETIME"
# }
# data "aws_secretsmanager_secret" DB_CONNECTION {
#   arn = "${var.secret_store}:DB_CONNECTION"
# }
# data "aws_secretsmanager_secret" DB_HOST {
#   arn = "${var.secret_store}:DB_HOST"
# }
# data "aws_secretsmanager_secret" DB_PORT {
#   arn = "${var.secret_store}:DB_PORT"
# }
# data "aws_secretsmanager_secret" DB_DATABASE {
#   arn = "${var.secret_store}:DB_DATABASE"
# }
# data "aws_secretsmanager_secret" DB_USERNAME {
#   arn = "${var.secret_store}:DB_USERNAME"
# }
# data "aws_secretsmanager_secret" DB_PASSWORD {
#   arn = "${var.secret_store}:DB_PASSWORD"
# }
# data "aws_secretsmanager_secret" MAIL_MAILER {
#   arn = "${var.secret_store}:MAIL_MAILER"
# }
# data "aws_secretsmanager_secret" MAIL_HOST {
#   arn = "${var.secret_store}:MAIL_HOST"
# }
# data "aws_secretsmanager_secret" MAIL_PORT {
#   arn = "${var.secret_store}:MAIL_PORT"
# }
# data "aws_secretsmanager_secret" MAIL_USERNAME {
#   arn = "${var.secret_store}:MAIL_USERNAME"
# }
# data "aws_secretsmanager_secret" MAIL_PASSWORD {
#   arn = "${var.secret_store}:MAIL_PASSWORD"
# }
# data "aws_secretsmanager_secret" MAIL_ENCRYPTION {
#   arn = "${var.secret_store}:MAIL_ENCRYPTION"
# }
# data "aws_secretsmanager_secret" MAIL_FROM_ADDRESS {
#   arn = "${var.secret_store}:MAIL_FROM_ADDRESS"
# }
# data "aws_secretsmanager_secret" MAIL_FROM_NAME {
#   arn = "${var.secret_store}:MAIL_FROM_NAME"
# }