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

resource "aws_lambda_function" "fetch_from_shodan" {
  function_name    = "FetchFromShodan"
  runtime         = "python3.13"
  handler         = "fetch_from_shodan.lambda_handler"
  filename        = "../Api/shodan_integration/shodan_integration.zip"
  role            = length(data.aws_iam_role.existing_role.id) > 0 ? data.aws_iam_role.existing_role.arn : aws_iam_role.lambda_role[0].arn
  timeout         = 30
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
        Resource = "arn:aws:s3:::S3-shodan-data/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  policy_arn = aws_iam_policy.s3_write_access.arn
  role       = length(data.aws_iam_role.existing_role.id) > 0 ? data.aws_iam_role.existing_role.name : aws_iam_role.lambda_role[0].name
}
