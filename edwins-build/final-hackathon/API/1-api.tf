
resource "aws_api_gateway_rest_api" "email_signup_api" {
  name = var.api_gw_rest_API_name
}

resource "aws_api_gateway_resource" "signup_resource" {
  rest_api_id = aws_api_gateway_rest_api.email_signup_api.id
  parent_id   = aws_api_gateway_rest_api.email_signup_api.root_resource_id
  path_part   = "subscribe"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.email_signup_api.id
  resource_id   = aws_api_gateway_resource.signup_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "post_method_response" {
  rest_api_id = aws_api_gateway_rest_api.email_signup_api.id
  resource_id = aws_api_gateway_resource.signup_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.email_signup_api.id
  resource_id = aws_api_gateway_resource.signup_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = var.api_uri
}

resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.email_signup_api.id
  resource_id = aws_api_gateway_resource.signup_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
  
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.email_signup_api.id
  resource_id   = aws_api_gateway_resource.signup_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.email_signup_api.id
  resource_id = aws_api_gateway_resource.signup_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.email_signup_api.id
  resource_id = aws_api_gateway_resource.signup_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  depends_on = [
    aws_api_gateway_integration.options_integration,
  ]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_rest_api.email_signup_api.id
  resource_id = aws_api_gateway_resource.signup_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration_response.post_integration_response,
    aws_api_gateway_method.options_method,
    aws_api_gateway_integration.options_integration,
    aws_api_gateway_integration_response.options_integration_response,  # Ensure the options integration is created before deployment
    aws_api_gateway_method_response.options_method_response,
  ]

  rest_api_id = aws_api_gateway_rest_api.email_signup_api.id
  stage_name  = "prod"
}
