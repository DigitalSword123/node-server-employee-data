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


terraform init -backend-config="key=employe-node-server/${TARGET_ENV_DEV}/terraform.tfstate"


terraform plan -var-file=dev-ap-south-1.tfvars

terraform apply -var-file=dev-ap-south-1.tfvars  -auto-approve 