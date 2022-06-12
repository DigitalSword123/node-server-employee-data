set -e

set env = "qa"


# export VAR_FILE ?= vars/qa-ap-south-1.tfvars

VAR_FILE="$(cat vars/qa-ap-south-1.tfvars)"

echo $env

echo $VAR_FILE

echo $(pwd)

terraform init -backend-config key="employe-node-server/${TARGET_ENV_QA}/terraform.tfstate"

terraform plan -var-file=$VAR_FILE 

terraform apply -var-file=$VAR_FILE  -auto-approve