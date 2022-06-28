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

terraform init \
 -backend-config="key=employe-node-server/${TARGET_ENV_UAT}/terraform.tfstate" \
  -backend-config="access_key=${AWS_ACCESS_KEY}" \
 -backend-config="secret_key=${AWS_SECRET_KEY}"

terraform plan -var-file=uat-ap-south-1.tfvars -out=tfplan

terraform apply "tfplan" 
# -var-file=uat-ap-south-1.tfvars -auto-approve 