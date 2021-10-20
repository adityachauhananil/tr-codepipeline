# Infrastructure as code(IAC) using DevOps Tools.

This repository maintains infrastructure as code using DevOps Tools

## Features

- Infrastructure provision for application server with fault tolerant and HA.
- Image building and registration using CI/CD.
- Auto-deploying of images using CI/CD.

## Tech

This project involves using many open-source tools:

- [Terraform](https://www.terraform.io/) - Tool for infrastructure creation!
- [Packer](https://www.packer.io/downloads) - Tool for Image creation!

## Installation

Follow below links for tools installation
- [Packer](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Pre-requisite
- Make sure you create an S3 bucket which will be used for state-management (In this case "terraform-tfstate25072021")
- Make sure you have permission to deploy the infrastructure on AWS platform using setting profile.
- Make sure you update ECR repo name in user-data.

## Terraform Code Structure

```sh
codepipeline/      # Codepipeline and its dependent resources.
common/            # Updation of permission for cross account role.
ecs-cluster/       # ECS cluster and its dependent resources.
infrastructure/    # Network and RDS resources.
s3/                # S3 bucket creation.
```

#### Terraform Usage
[1] First you need to deploy the networking and DB layer, use below command to do so.
```sh
$ cd infrastructure
$ terraform init -backend-config=environments/dev/env.backendconfig
$ terraform plan --var-file=environments/dev/dev.tfvars    # Plan the changes
$ terraform apply --var-file=environments/dev/dev.tfvars  # apply the changes
```
[2] Next, you need to deploy the web-server.
```sh
$ cd s3
$ terraform init -backend-config=environments/dev/env.backendconfig
$ terraform plan  --var-file=environments/dev/dev.tfvars  # Plan the changes
$ terraform apply --var-file=environments/dev/dev.tfvars  # apply the changes
```
[3] Repeat the above steps for ecs-cluster, codepipeline and common resources.


#### How it works in terraform
We are using [user-data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) to setup the pre-installed and initial deploy of code.