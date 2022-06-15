set -e

set env = "qa"

echo $(pwd)

# export VAR_FILE ?= vars/qa-ap-south-1.tfvars

VAR_FILE=$(<./terraform_project/vars/qa-ap-south-1.tfvars)

echo $env

echo $VAR_FILE

cd terraform_project

ls -al

echo ${TARGET_ENV_QA}

terraform fmt

terraform init -backend-config="key=employe-node-server/${TARGET_ENV_QA}/terraform.tfstate"

terraform plan -var-file=qa-ap-south-1.tfvars -out=tfplan

terraform apply "tfplan" -var-file=qa-ap-south-1.tfvars  -auto-approve 