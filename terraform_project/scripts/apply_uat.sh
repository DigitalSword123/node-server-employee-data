set -e

set env = "uat"

echo $(pwd)

# VAR_FILE ?= vars/uat-ap-south-1.tfvars

VAR_FILE="$(cat ./terraform_project/vars/uat-ap-south-1.tfvars)"

echo $env

cd terraform_project
ls -al
terraform init -backend-config key="employe-node-server/${TARGET_ENV_UAT}/terraform.tfstate"

terraform plan -var-file='$VAR_FILE' 

terraform apply -var-file='$VAR_FILE'  -auto-approve