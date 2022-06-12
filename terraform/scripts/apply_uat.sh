set -e

set env = "uat"

FILE ?= vars/uat-ap-south-1.tfvars

echo $env

echo $(pwd)

terraform init -backend-config key="employe-node-server/${TARGET_ENV_UAT}/terraform.tfstate"

terraform plan -var-file=$FILE 

terraform apply -var-file=$FILE  -auto-approve