data "aws_caller_identity" "current_account" {}

data "aws_ssm_parameter" "lambda-execution-role-arn" {
  name = "/project/${data.aws_caller_identity.current_account.account_id}/iam/lambda-execution-role-arn"
}

data "terraform_remote_state" "paramerstore" {
  backend = "s3"
  config = {
    bucket = var.state-bucket
    key    = "/project/${var.destination-region}/${lower(var.environment)}/terraform.tfstate"
    region = var.destination-region
  }
}

data "aws_ssm_parameter" "ssm_params" {
  for_each = data.terraform_remote_state.paramerstore.outputs.ssm_map
  name     = "${var.ssm_path}/${lower(var.environment)}/${each.key}"
}

locals {
  ssm_map = {
    for key, value in data.terraform_remote_state.paramerstore.outputs.ssm_map :
    replace(upper(key), "/", "_") => data.aws_ssm_parameter.ssm_params[key].value
  }
}

resource "aws_lambda_function" "lambda" {
  function_name    = var.function_name
  filename         = var.filename
  source_code_hash = filebasesha256(var.filename)
  role             = var.role
  handler          = var.handler
  runtime          = var.runtime
  memory_size      = var.memory
  timeout          = var.timeout

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