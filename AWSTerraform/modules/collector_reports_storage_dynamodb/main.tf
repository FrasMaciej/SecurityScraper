resource "aws_dynamodb_table" "collector_reports_storage" {
  name           = var.collector_reports_storage_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PrimaryKey"

  attribute {
    name = "PrimaryKey"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  ttl {
    attribute_name = "TimeToLive"
    enabled        = true
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "collector_reports_storage_dynamodb_policy"
  description = "Policy to enforce secure access to DynamoDB table"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/${var.collector_reports_storage_table_name}",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}