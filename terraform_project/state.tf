# tis .tfstate file in s3 bucket will store already provisioned
# infrastrucrures like lambda, bucket which are created previous terraform
# apply command
terraform {
  backend "s3" {
    bucket     = "employee-data-node-terraform-state-bucket"
    encrypt    = false
    # key     = "employe-node-server/env/terraform.tfstate" # this key 
    # is being called in shell commands present in scripts folder
    region     = "ap-south-1"
    AWS_ACCESS_KEY_ID  = "AKIAZ332BW4JK4JM2BMC"
    AWS_SECRET_ACCESS_KEY  = "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"
    # access_key = "AKIAZ332BW4JOYRQTLGD"
    # secret_key = "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"
  }
}