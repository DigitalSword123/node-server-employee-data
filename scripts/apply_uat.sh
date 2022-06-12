set -e

set env = "uat"

FILE ?= vars/uat-ap-south-1.tfvars

echo $env

echo $(pwd)

terraform init

terraform plan -var-file=$FILE 

terraform apply -var-file=$FILE  -auto-approve