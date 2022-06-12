set -e

set env = "prod"

# VAR_FILE ?= vars/prod-ap-south-1.tfvars

VAR_FILE="$(cat vars/prod-ap-south-1.tfvars)"

echo $env

echo $(pwd)

terraform init -backend-config key="employe-node-server/${TARGET_ENV_PROD}/terraform.tfstate"

terraform plan -var-file=$VAR_FILE 

terraform apply -var-file=$VAR_FILE  -auto-approve