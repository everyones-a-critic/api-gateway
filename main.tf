provider "aws" {
  region = var.region
}

resource "aws_api_gateway_rest_api" "main" {
  name = "everyones-a-critic"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_authorizer" "cognito" {
  name          = "cognito"
  rest_api_id   = aws_api_gateway_rest_api.main.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = var.cognito_pools
}