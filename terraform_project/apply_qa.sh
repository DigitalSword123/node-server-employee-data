set -e

set env = "qa"

VAR_FILE ?= vars/qa-ap-south-1.tfvars

echo $env

echo $(pwd)

terraform init -backend-config key="employe-node-server/${TARGET_ENV_QA}/terraform.tfstate"

terraform plan -var-file=$VAR_FILE 

terraform apply -var-file=$VAR_FILE  -auto-approve