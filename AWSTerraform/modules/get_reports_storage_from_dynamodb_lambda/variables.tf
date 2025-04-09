variable "aws_region"{
    type = string
}

variable "collector_reports_storage_table_name" {
    type = string
}

variable "shodan_collector_api_id" {
  description = "The ID of the existing API Gateway for shodan-collector"
  type        = string
}