provider "aws" {
  region  = "us-west-2"
  # profile = "default"
}

terraform {
  backend "s3" {
    bucket  = "iac-pipeline-test-2021"
    key     = "devIacPipeline.tfstate"
    # profile = "default"
  }
}
