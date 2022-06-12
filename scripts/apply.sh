echo $env

echo $(pwd)

cd ../env/${env}

echo $(pwd)
echo $FILE

terraform init
terraform plan -var-file=$FILE 

terraform apply -var-file=$FILE  -auto-approve