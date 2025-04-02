resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

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

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "ssm_parameter_access" {
  name        = "SSMParameterAccessPolicy"
  description = "Allows Lambda to read SSM Parameter Store for /securityscraper/shodan/apikey"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParameterHistory"
      ]
      Resource = "arn:aws:ssm:eu-central-1:${data.aws_caller_identity.current.account_id}:parameter/securityscraper/shodan/apikey"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  policy_arn = aws_iam_policy.ssm_parameter_access.arn
  role       = aws_iam_role.lambda_role.name
}

resource "null_resource" "install_dependencies" {
  provisioner "local-exec" {
    command = <<EOT
      rm -f ../Api/shodan_collector_lambda/shodan_collector_lambda.zip
      pip install -r ../Api/shodan_collector_lambda/requirements.txt -t ../Api/shodan_collector_lambda/
    EOT
  }
  triggers = {
    always_run = timestamp()
  }
}

data "archive_file" "shodan_collector_lambda_package" {
  type        = "zip"
  source_dir  = "../Api/shodan_collector_lambda/"
  output_path = "../Api/shodan_collector_lambda/shodan_collector_lambda.zip"
  depends_on  = [null_resource.install_dependencies]
}

resource "aws_lambda_function" "shodan_collector_lambda" {
  function_name    = "shodan_collector_lambda"
  runtime          = "python3.13"
  handler          = "shodan_collector_lambda.lambda_handler"
  filename         = data.archive_file.shodan_collector_lambda_package.output_path
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = data.archive_file.shodan_collector_lambda_package.output_base64sha256
  timeout          = 30
  depends_on = [
    data.archive_file.shodan_collector_lambda_package,
  ]
}

resource "aws_iam_policy" "s3_write_access" {
  name        = "S3WriteAccessPolicy"
  description = "Allows Lambda to write objects to S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "arn:aws:s3:::s3-shodan-data/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  policy_arn = aws_iam_policy.s3_write_access.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name       = "lambda_logs"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}