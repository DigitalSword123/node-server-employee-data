set -e

set env = "uat"

# VAR_FILE ?= vars/uat-ap-south-1.tfvars

VAR_FILE="$(cat vars/uat-ap-south-1.tfvars)"

echo $env

echo $(pwd)

terraform init -backend-config key="employe-node-server/${TARGET_ENV_UAT}/terraform.tfstate"

terraform plan -var-file=$VAR_FILE 

terraform apply -var-file=$VAR_FILE  -auto-approve