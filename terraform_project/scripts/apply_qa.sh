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

terraform init -backend-config="key=employe-node-server/${TARGET_ENV_QA}/terraform.tfstate" -out=employee-node-data.1.0.0-SNAPSHOT.zip

terraform plan -var-file=qa-ap-south-1.tfvars

terraform apply -var-file=qa-ap-south-1.tfvars  -auto-approve 