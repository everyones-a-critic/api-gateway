output "gateway_id" {
  value       = aws_api_gateway_rest_api.main.id
}

output "root_resource_id" {
  value       = aws_api_gateway_rest_api.main.root_resource_id
}

output "authorizer_id" {
    value = aws_api_gateway_authorizer.cognito.id
}