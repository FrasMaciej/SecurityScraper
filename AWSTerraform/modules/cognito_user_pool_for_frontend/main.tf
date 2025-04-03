resource "aws_cognito_user_pool" "this" {
  name = var.pool_name

  auto_verified_attributes = ["email"]



  schema {
    name = "email"
    required = true
    attribute_data_type = "String"
    mutable = true
  }

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = false
  }

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  mfa_configuration = "OFF"
}
