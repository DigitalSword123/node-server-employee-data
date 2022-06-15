# tis .tfstate file in s3 bucket will store already provisioned
# infrastrucrures like lambda, bucket which are created previous terraform
# apply command
# root access key
# access_key = "AKIAZ332BW4JOYRQTLGD" 
# secret_key = "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"
terraform {
  backend "s3" {
    bucket     = "employee-data-node-terraform-state-bucket"
    encrypt    = false
    region     = "ap-south-1"
    access_key = "AKIAZ332BW4JOYRQTLGD"
    secret_key = "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"
  }
}
