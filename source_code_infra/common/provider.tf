provider "aws" {
  region  = var.region
  profile = "dev"
}

#terraform {
#  backend "s3" {
#  }
#  required_version = ">= 0.12"
#}
terraform {
  backend "s3" {
    bucket   = "fsc-terraform-tfstate-2021"
    key      = "cross-account-commonv2.tfstate"
    region   = "us-west-2"
    profile  = "shared"
  }
}
