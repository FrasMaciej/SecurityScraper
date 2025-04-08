output "user_pool_id" {
  value = aws_cognito_user_pool.this.id
}

output "client_id" {
  value = aws_cognito_user_pool_client.frontend_client.id
}

output "cognito_authority" {
  value = aws_cognito_user_pool.this.endpoint
}

output "cognito_redirect_uri" {
  value = tolist(aws_cognito_user_pool_client.frontend_client.callback_urls)[0]
}