set -e

set env = "dev"

echo $(pwd)

ls -al

# VAR_FILE ?= vars/dev-ap-south-1.tfvars

# VAR_FILE=$(<./terraform_project/vars/dev-ap-south-1.tfvars)
# VAR_FILE ?= ./terraform_project/vars/dev-ap-south-1.tfvars
# read VAR_FILE < ./terraform_project/vars/dev-ap-south-1.tfvars

# echo $env



# echo $VAR_FILE

cd terraform_project

ls -al

echo ${TARGET_ENV_DEV}

terraform fmt

terraform init \
 -backend-config="key=employe-node-server/${TARGET_ENV_DEV}/terraform.tfstate" \
 -backend-config="access_key=${AWS_ACCESS_KEY}" \
 -backend-config="secret_key=${AWS_SECRET_KEY}"


terraform plan -var-file=dev-ap-south-1.tfvars -out=tfplan

terraform apply "tfplan"
#  -var-file=dev-ap-south-1.tfvars -auto-approve 