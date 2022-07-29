set -e

set env = "dev"

echo $(pwd)

ls -al

echo ${TARGET_ENV_DEV}

VAR_FILE=`cat vars/${TARGET_ENV_DEV}-ap-south-1.tfvars`

echo "${VAR_FILE}"

cd terraform_project

ls -al


terraform fmt

terraform init \
 -backend-config="key=employe-node-server/${TARGET_ENV_DEV}/terraform.tfstate" \
 -backend-config="access_key=${AWS_ACCESS_KEY}" \
 -backend-config="secret_key=${AWS_SECRET_KEY}"



terraform plan -var-file="${VAR_FILE}" -out=tfplan

terraform apply "tfplan"
