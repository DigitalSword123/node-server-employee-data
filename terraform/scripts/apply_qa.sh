set -e

set env = "qa"

FILE ?= vars/qa-ap-south-1.tfvars

echo $env

echo $(pwd)

terraform init -backend-config key="employe-node-server/${TARGET_ENV_QA}/terraform.tfstate"

terraform plan -var-file=$FILE 

terraform apply -var-file=$FILE  -auto-approve