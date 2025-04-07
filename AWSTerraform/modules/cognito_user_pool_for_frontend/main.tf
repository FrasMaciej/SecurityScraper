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

resource "aws_cognito_user_pool_client" "frontend_client" {
  name         = "frontend-client"
  user_pool_id = aws_cognito_user_pool.this.id
  generate_secret = false

  callback_urls = [
    var.callback_url
  ]

  logout_urls = [
    var.logout_url
  ]

    allowed_oauth_flows_user_pool_client = true

  allowed_oauth_flows = [
    "code"
  ]

  allowed_oauth_scopes = [
    "email",
    "openid",
    "profile"
  ]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_pool_domain" "this" {
  domain       = var.cognito_domain_prefix
  user_pool_id = aws_cognito_user_pool.this.id
}