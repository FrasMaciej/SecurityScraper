terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_iam_role" "existing_role" {
  name = "lambda_execution_role"
}

resource "aws_iam_role" "lambda_role" {
  count = length(data.aws_iam_role.existing_role.id) == 0 ? 1 : 0
  name  = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "ssm_parameter_access" {
  count        = length(data.aws_iam_policy.existing_ssm_parameter_access.id) == 0 ? 1 : 0
  name         = "SSMParameterAccessPolicy"
  description  = "Allows Lambda to read SSM Parameter Store for /securityscraper/shodan/apikey"

  policy       = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParameterHistory"
      ]
      Resource = "arn:aws:ssm:eu-central-1:${data.aws_caller_identity.current.account_id}:parameter/securityscraper/shodan/apikey"
    }]
  })
}

data "aws_iam_policy" "existing_ssm_parameter_access" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/SSMParameterAccessPolicy"
}

resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  policy_arn = data.aws_iam_policy.existing_ssm_parameter_access.arn
  role       = length(data.aws_iam_role.existing_role.id) > 0 ? data.aws_iam_role.existing_role.name : aws_iam_role.lambda_role[0].name
}

data "aws_caller_identity" "current" {}

resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = <<EOT
      rm -f ../Api/shodan_integration.zip
      pip install -r ../Api/shodan_integration/requirements.txt -t ../Api/shodan_integration/
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
}

data "archive_file" "fetch_from_shodan_lambda_package" {
  type        = "zip"
  source_dir  = "../Api/shodan_integration/"   
  output_path = "../Api/shodan_integration/shodan_integration.zip"
  depends_on  = [null_resource.install_dependencies]
}

resource "aws_lambda_function" "fetch_from_shodan" {
  function_name    = "FetchFromShodan"
  runtime         = "python3.13"
  handler         = "fetch_from_shodan.lambda_handler"
  filename        = data.archive_file.fetch_from_shodan_lambda_package.output_path
  role            = length(data.aws_iam_role.existing_role.id) > 0 ? data.aws_iam_role.existing_role.arn : aws_iam_role.lambda_role[0].arn
  source_code_hash = data.archive_file.fetch_from_shodan_lambda_package.output_base64sha256
  timeout          = 30
  depends_on = [
    data.archive_file.fetch_from_shodan_lambda_package,
  ]

  lifecycle {
    ignore_changes = [source_code_hash]
  }
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda_logs"
  roles      = length(data.aws_iam_role.existing_role.id) > 0 ? [data.aws_iam_role.existing_role.name] : [aws_iam_role.lambda_role[0].name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
