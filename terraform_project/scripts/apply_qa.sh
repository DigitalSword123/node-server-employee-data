set -e

set env = "qa"

echo $(pwd)

# export VAR_FILE ?= vars/qa-ap-south-1.tfvars

VAR_FILE=$(<./terraform_project/vars/qa-ap-south-1.tfvars)

echo $env

echo $VAR_FILE

cd terraform_project

ls -al

terraform init -backend-config key="employe-node-server/${TARGET_ENV_QA}/terraform.tfstate"

terraform plan -var-file="$VAR_FILE"

terraform apply -var-file="$VAR_FILE"  -auto-approve