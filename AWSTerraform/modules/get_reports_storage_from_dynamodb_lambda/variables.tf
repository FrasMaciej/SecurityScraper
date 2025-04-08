variable "aws_region"{
    type = string
}

variable "collector_reports_storage_table_name" {
    type = string
}

variable "lambda_role_arn" {
  description = "IAM role ARN for the Lambda function"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}