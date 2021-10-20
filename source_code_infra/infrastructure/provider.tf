provider "aws" {
  region  = var.region
  profile = ""
}

#terraform {
#  backend "s3" {
#  }
#  required_version = ">= 0.12"
#}
terraform {
  backend "s3" {
    bucket  = "mybucketvishnu02"
    key     = "mybucketvishnu.tfstate"
    region  = "us-west-2"
    profile = "shared"
  }
}
