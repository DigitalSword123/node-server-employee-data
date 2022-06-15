set -e

set env = "prod"

echo $(pwd)

# VAR_FILE ?= vars/prod-ap-south-1.tfvars

VAR_FILE=$(<./terraform_project/vars/prod-ap-south-1.tfvars)

# echo $env

cd terraform_project

ls -al

echo ${TARGET_ENV_PROD}

terraform fmt

terraform init -backend-config="key=employe-node-server/${TARGET_ENV_PROD}/terraform.tfstate"

terraform plan -var-file=prod-ap-south-1.tfvars -out=tfplan

terraform apply "tfplan" -var-file=prod-ap-south-1.tfvars  -auto-approve 