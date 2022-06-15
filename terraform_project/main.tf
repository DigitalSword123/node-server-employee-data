provider "aws" {
  # shared_credentials_file = "$HOME/.aws/credentials"
  # profile = "default"
  region     = "ap-south-1"
  access_key = "AKIAZ332BW4JK4JM2BMC"
  secret_key = "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"
  # access_key = "AKIAZ332BW4JOYRQTLGD"
  # secret_key = "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"
}

data "aws_caller_identity" "current_account" {}

data "aws_ssm_parameter" "private_subnets" {
  name = "/project/${lower(var.env)}/private/subnets"
}

# value = "subnet-0c14e9c0fe63b3a69,subnet-0930e143f6943384d,subnet-06234b18eb06fc83a" private_subnets
# value = "10.0.0.0/8"  allowed_ssh_ips
# value = "vpc-05b050daa09deb4d0" vpc-id
# value = "678323926802" # amazon iam user id principal_ids
 # value = "arn:aws:iam::678323926802:role/Lambda-nodejs-executionrole"  lambda_role
 

data "aws_ssm_parameter" "allowed_ssh_ips" {
  name = "/project/${lower(var.env)}/ssh/ips"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/project/${lower(var.env)}/vpc/id"

}

# data "aws_ssm_parameter" "principal_ids" {
#   name = "/project/${lower(var.env)}/principal/ids"
# }

data "aws_ssm_parameter" "node_project" {
  name = "/project/${lower(var.env)}/lambda/runtime/nodeProject" #"nodejs14.x"
}

data "aws_ssm_parameter" "lambda_role" {
  name = "/project/${lower(var.env)}/lambda/role"
}

data "aws_ssm_parameter" "lambda_memory" {
  name = "/project/${lower(var.env)}/lambda/memory"
}

  # value = "128"

data "aws_ssm_parameter" "lambda_timeout" {
  name = "/project/${lower(var.env)}/lambda/timeout"
}

  # value = "60"

data "aws_ssm_parameter" "lambda_state_bucket" {
  name = "/project/${lower(var.env)}/lambda/stateBucket"
}

# value = "employee-data-node-terraform-state-bucket"

data "aws_ssm_parameter" "run_time" {
  name = "/project/${lower(var.env)}/lambda/runtime"
}

  # value = "nodejs14.x"

module "lambda_node_project_sg" {
  source      = "./modules/sg"
  name        = "${var.name}-SG-${upper(var.env)}"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  ingresscidr = split(",", data.aws_ssm_parameter.allowed_ssh_ips.value)
  environment = upper(var.env)
  tags = merge(var.default_master_tags,var.master_tags,tomap({"Name" = "${var.name}-sg-${upper(var.env)}"}))
}

#################################
# Lambda: rest api for employee
#################################

module "lambda_employee_data" {
  source                = "./modules/lambda"
  security_group_ids    = [module.lambda_node_project_sg.sg_id]                                         #done
  filename              = var._lambda_properties["lambda_zip_file_employee_data"]                       #done
  function_name         = "${var.project}-${var._lambda_properties["Lambda_function_name"]}-${var.env}" #done
  # handler               = var._lambda_properties["lambda_handler"]                                      #done
  role                  = data.aws_ssm_parameter.lambda_role.value                                      # done
  # runtime               = data.aws_ssm_parameter.run_time                                               #done
  memory                = data.aws_ssm_parameter.lambda_memory                                          #done
  # timeout               = data.aws_ssm_parameter.lambda_timeout                                         #done
  subnet_ids            = split(",", data.aws_ssm_parameter.private_subnets.value)                      # done
  # principal_ids         = toset(split(",", data.aws_ssm_parameter.principal_ids.value))                 # done
  state-bucket          = data.aws_ssm_parameter.lambda_state_bucket.value                              #done
  tags                  = merge(var.default_master_tags, var.master_tags)                               #done
  environment_variables = var.environment_variables                                                     #done
  environment           = lower(var.env)                                                                #done
}
