set -e

set env = "uat"

echo $(pwd)

# VAR_FILE ?= vars/uat-ap-south-1.tfvars

VAR_FILE=$(<./terraform_project/vars/uat-ap-south-1.tfvars)

echo $env

cd terraform_project
ls -al

echo ${TARGET_ENV_UAT}

terraform fmt

terraform init -backend-config="key=employe-node-server/${TARGET_ENV_UAT}/terraform.tfstate" -out=employee-node-data.1.0.0-SNAPSHOT.zip

terraform plan -var-file=uat-ap-south-1.tfvars

terraform apply -var-file=uat-ap-south-1.tfvars  -auto-approve 