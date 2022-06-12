set -e

set env = "dev"

echo $(pwd)

ls -al

# VAR_FILE ?= vars/dev-ap-south-1.tfvars

VAR_FILE="$(cat ./vars/dev-ap-south-1.tfvars)"

echo $env

echo $VAR_FILE

terraform init -backend-config key="employe-node-server/${TARGET_ENV_DEV}/terraform.tfstate"

terraform plan -var-file=$VAR_FILE 

terraform apply -var-file=$VAR_FILE  -auto-approve