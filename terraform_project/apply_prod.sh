set -e

set env = "prod"

echo $(pwd)

# VAR_FILE ?= vars/prod-ap-south-1.tfvars

VAR_FILE="$(cat ./terraform_project/vars/prod-ap-south-1.tfvars)"

echo $env

cd terraform_project

ls -al

terraform init -backend-config key="employe-node-server/${TARGET_ENV_PROD}/terraform.tfstate"

terraform plan -var-file=$VAR_FILE 

terraform apply -var-file=$VAR_FILE  -auto-approve