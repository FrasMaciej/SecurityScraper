variable "collector_reports_storage_table_name" {
  description = "Name of the DynamoDB table for collector reports storage"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}