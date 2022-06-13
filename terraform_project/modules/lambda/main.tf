data "aws_caller_identity" "current_account" {}

data "aws_ssm_parameter" "lambda-execution-role-arn" {
  name = "/project/${var.environment}/${data.aws_caller_identity.current_account.account_id}/iam/lambda-execution-role-arn"
}

data "terraform_remote_state" "paramerstore" {
  backend = "s3"
  config = {
    bucket = "employee-data-node-terraform-state-bucket" #var.state-bucket
    key    = "param-store/${lower(var.environment)}/terraform.tfstate"
    region = var.destination-region
    access_key = "AKIAZ332BW4JK4JM2BMC"
    secret_key = "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"
  }
}

data "aws_ssm_parameter" "ssm_params" {
  for_each = data.terraform_remote_state.paramerstore.outputs.ssm_map
  name     = "${var.ssm-path}/${lower(var.environment)}/${each.key}"
}

locals {
  ssm_map = {
    for key, value in data.terraform_remote_state.paramerstore.outputs.ssm_map :
    replace(upper(key), "/", "_") => data.aws_ssm_parameter.ssm_params[key].value
  }
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  filename         = "${path.module}/${var.filename}"
  source_code_hash = filebase64sha256("${path.module}/${var.filename}")
  role             = var.role
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  memory_size      = 128
  timeout          = 60

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = merge(var.environment_variables, local.ssm_map)
  }

  tags = var.tags
}

resource "aws_lambda_permission" "allow_invoke_permission" {
  statement_id  = "Allowingtoinvokeotheraccount-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  for_each      = var.principal_ids
  principal     = each.key
}