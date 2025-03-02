provider "aws" {
  region = "eu-central-1"
}

data "aws_iam_role" "existing_role" {
  name = "lambda_execution_role"
}

resource "aws_iam_role" "lambda_role" {
  count              = length(data.aws_iam_role.existing_role.id) == 0 ? 1 : 0
  name               = "lambda_execution_role"
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

resource "aws_lambda_function" "my_lambda" {
  function_name    = "MyLambdaFunction"
  runtime         = "python3.13"
  handler         = "main.lambda_handler"
  filename        = data.archive_file.lambda_package.output_path
  role            = length(data.aws_iam_role.existing_role.id) > 0 ? data.aws_iam_role.existing_role.arn : aws_iam_role.lambda_role[0].arn
  source_code_hash = filebase64sha256(data.archive_file.lambda_package.output_path)
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "../lambda_function/"
  output_path = "../lambda_function.zip"
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda_logs"
  roles      = length(data.aws_iam_role.existing_role.id) > 0 ? [data.aws_iam_role.existing_role.name] : [aws_iam_role.lambda_role[0].name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
