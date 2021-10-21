# Infrastructure as code(IAC) Pipeline.



terraform init -backend-config=environments/dev/env.backendconfig
terraform plan --var-file=environments/dev/dev.tfvars    # Plan the changes
terraform apply --var-file=environments/dev/dev.tfvars  # apply the changes