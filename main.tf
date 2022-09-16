provider "aws" {
  region = var.region
}

data "tfe_outputs" "cognito" {
  organization = "everyones-a-critic"
  workspace    = "cognito"
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
  provider_arns = [data.tfe_outputs.cognito.values.congito_pool_id]
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "prod"
}

resource "aws_acm_certificate" "api" {
  domain_name       = "api.everyonesacriticapp.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# waiting for the certificate to be approved
resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_acm_certificate.api]

  create_duration = "30s"
}


resource "aws_api_gateway_domain_name" "main" {
  depends_on               = [time_sleep.wait_30_seconds]
  regional_certificate_arn = aws_acm_certificate.api.id
  domain_name              = "api.everyonesacriticapp.com"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "example" {
  api_id      = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.prod.stage_name
  domain_name = aws_api_gateway_domain_name.main.domain_name
}

resource "aws_route53_record" "example" {
  name    = aws_api_gateway_domain_name.main.domain_name
  type    = "A"
  zone_id = var.route_53_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.main.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.main.regional_zone_id
  }
}