provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

data "aws_ssm_parameter" "private_subnets" {
  name = "/project/${lower(var.env)}/private/subnets"
}

data "aws_ssm_parameter" "allowed_ssh_ips" {
  name = "/project/${lower(var.env)}/ssh/ips"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/project/${lower(var.env)}/vpc/id"
}

data "aws_ssm_parameter" "principal_ids" {
  name = "/project/${lower(var.env)}/principal/ids"
}

data "aws_ssm_parameter" "node_project" {
  name = "/project/${lower(var.env)}/lambda/runtime/nodeProject"
}

data "aws_ssm_parameter" "lambda_role" {
  name = "/project/${lower(var.env)}/lambda/role"
}

data "aws_ssm_parameter" "lambda_memory" {
  name = "/project/${lower(var.env)}/lambda/memory"
}

data "aws_ssm_parameter" "lambda_timeout" {
  name = "/project/${lower(var.env)}/lambda/timeout"
}

data "aws_ssm_parameter" "lambda_state_bucket" {
  name = "/project/${lower(var.env)}/lambda/stateBucket"
}

data "aws_ssm_parameter" "run_time" {
  name = "/project/${lower(var.env)}/lambda/run_time"
}

module "lambda_node_project_sg" {
  source      = "./modules/sg"
  name        = "${var.name}-SG-${upper(var.env)}"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  ingresscidr = split(",", data.aws_ssm_parameter.allowed_ssh_ips.value)
  environment = upper(var.env)
}

#################################
# Lambda: rest api for employee
#################################

module "lambda_employee_data" {
  source                = "./modules/lambda"
  security_group_ids    = [module.lambda_node_project_sg.sg_id]
  filename              = var._lambda_properties["lambda_zip_file_employee_data"]
  function_name         = "${var.project}-${var._lambda_properties["Lambda_function_name"]}-${var.env}"
  handler               = var._lambda_properties["lambda_handler"]
  role                  = data.aws_ssm_parameter.lambda_role.value
  runtime               = data.aws_ssm_parameter.run_time
  memory                = data.aws_ssm_parameter.lambda_memory
  timeout               = data.aws_ssm_parameter.lambda_timeout
  subnet_ids            = split(",", data.aws_ssm_parameter.private_subnets.value)
  principal_ids         = toset(split(",", data.aws_ssm_parameter.principal_ids.value))
  state-bucket          = data.aws_ssm_parameter.lambda_state_bucket.value
  tags                  = merge(var.default_master_tags, var.master_tags)
  environment_variables = var.environment_variables
  environment           = lower(var.env)
}