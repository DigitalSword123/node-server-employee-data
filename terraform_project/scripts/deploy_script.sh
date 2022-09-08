source dist-${MODULE_NAME}
echo "--------------------Switching to dist directory-------------------"
cd dist-${MODULE_NAME}
echo "printing all files in target directory"

ls -altr

echo "------------------printing all files in target directory end --------------------------"
echo "STATE_BUCKET" $STATE_BUCKET
echo "AWSENV" $AWSENV
echo "AWS_REGION" $AWS_REGION
echo "AWS_ACCOUNT_NUMBER" $AWS_ACCOUNT_NUMBER
echo "DYNDB_TBL" $DYNDB_TBL
echo "IAM_ROLE" $IAM_ROLE

echo "**********************************************************"
pwd
# echo "unzip ZIP from tgz from tgz_output directory"
# unzip -o *.zip -d TF_OUTPUT
# pwd
# ls -altr
# RESULT=$?

# if  [ $RESULT -eq 0 ]; then
#     echo "success"
# else
#     echo "failed"
# fi

# echo "switching to TF_OUTPUT_DIR"
# cd TF_OUTPUT
# echo "printing all files in TF_OUTPUT directory"
# pwd
# ls -altr
# pip install envsubst
# envsubst < terragrunt.hcl_template > tearragrunt.hcl

# if  [ $? -eq 0 ]; then
#     echo "success"
# else
#     echo "failed"
# fi
# envl=$(echo "$DEPLOY_ENVIRONMENT" | tr '[:upper:]' '[:lower:]')
# export AWSENVLOWER=$envl
# echo "printing terragrunt.hcl file"
# cat terragrunt.hcl
# echo "printing $AWSENVLOWER-terraform.tfvars file"
# echo "Terraform Version : "
# terraform --version

# cd terraform_project

# echo "$(pwd)"

# ls -al

export VAR_FILE=vars/$DEPLOY_ENVIRONMENT-ap-south-1.tfvars

cat ${VAR_FILE}

echo "DEPLOY_ENVIRONMENT : " $DEPLOY_ENVIRONMENT

terraform init \
 -backend-config="key=employe-node-server/$DEPLOY_ENVIRONMENT/terraform.tfstate" \
 -backend-config="access_key=${AWS_ACCESS_KEY}" \
 -backend-config="secret_key=${AWS_SECRET_KEY}"

terraform plan -var-file="${VAR_FILE}" -out=plan.tfplan

terraform apply "plan.tfplan"