resource "aws_s3_bucket" "website_bucket" {
  bucket = var.website_bucket_name
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "website_bucket_ownership" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_object" "privacy_policy_html" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "privacy-policy.html"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/privacy-policy.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "styles.css"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/styles.css"
  content_type = "text/css"
}

resource "aws_s3_object" "success_html" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "success.html"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/success.html"
  content_type = "text/html"
}

resource "aws_s3_object" "cd_tech_chattanooga_logo" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "assets/CD_Tech_Chattanooga_Logo.jpg"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/assets/CD_Tech_Chattanooga_Logo.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_object" "abstract_chattskyline" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "assets/abstract_chattskyline.jpg"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/assets/abstract_chattskyline.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_object" "chattskyline" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "assets/chattskyline.jpg"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/assets/chattskyline.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_bucket" "email_storage_bucket" {
  bucket = var.email_storage_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "email_storage_bucket_ownership" {
  bucket = aws_s3_bucket.email_storage_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "email_storage_bucket_public_access" {
  bucket = aws_s3_bucket.email_storage_bucket.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_s3_policy"
  description = "Policy for Lambda to access S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket" // Added ListBucket for listing bucket contents
        ],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::${var.email_storage_bucket_name}",
          "arn:aws:s3:::${var.email_storage_bucket_name}/*"
        ],
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "email_signup" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.lambda_handler"  // Corrected handler name
  runtime       = "python3.12"  // Updated runtime
  filename      = "../backend/lambda_function.zip"  // Update this path as needed

  source_code_hash = filebase64sha256("../backend/lambda_function.zip")

  environment {
    variables = {
      EMAIL_STORAGE_BUCKET = var.email_storage_bucket_name
    }
  }
}

resource "aws_api_gateway_rest_api" "email_signup_api" {
  name = "EmailSignupAPI"
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
  uri         = aws_lambda_function.email_signup.invoke_arn
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

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_signup.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.email_signup_api.execution_arn}/*/*"
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
