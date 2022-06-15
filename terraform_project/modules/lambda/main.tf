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
    # access_key = "AKIAZ332BW4JK4JM2BMC"
    # secret_key = "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"
    access_key = "AKIAZ332BW4JOYRQTLGD"
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
 
locals{
  lambda_file_zip_location="${var.filename}"
}
data "archive_file" "employee_lambda"{
  type="zip"
  source_dir = "${path.root}/../../src"
  output_path="${local.lambda_file_zip_location}"
}
resource "aws_lambda_function" "lambda_employee_node_server" {
  function_name    = var.function_name
  filename         = "${path.module}/${var.filename}"
  # source_code_hash = "{filebase64sha256$(${path.module}/${var.filename})}"
  source_code_hash = "${filebase64sha256(local.lambda_file_zip_location)}"
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
  statement_id  = "Allowingtoinvokeotheraccount-678323926802"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_employee_node_server.function_name
  # for_each      = var.principal_ids
  principal     = "678323926802"
}


# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging_employee" {
  name = "lambda_logging_employee"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "Lambda-nodejs-executionrole"
  policy_arn = "${aws_iam_policy.lambda_logging_employee.arn}"
}