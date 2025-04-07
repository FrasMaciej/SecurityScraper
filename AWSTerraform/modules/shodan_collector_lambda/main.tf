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
        Resource = "arn:aws:s3:::collector-reports-storage-s3/*"
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

resource "aws_apigatewayv2_api" "shodan_collector_api" {
  name          = "shodan-collector-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.shodan_collector_api.id
  name   = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.shodan_collector_api.id
  integration_type = "AWS_PROXY"

  connection_type    = "INTERNET"
  description        = "Lambda integration"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.shodan_collector_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.shodan_collector_api.id
  route_key = "POST /collect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shodan_collector_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.shodan_collector_api.execution_arn}/*/*"
}

output "shodan_collector_api_url" {
  value = "${aws_apigatewayv2_stage.stage.invoke_url}/collect"
}