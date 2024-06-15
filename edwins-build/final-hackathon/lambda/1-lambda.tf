data "archive_file" "lambda_handler_function" {
  type = "zip"
  source_file = var.lambda_function_file_path
  output_path = "lambda_function.zip"
  
}

resource "aws_lambda_function" "email_signup" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.lambda_handler"  // Corrected handler name
  runtime       = "python3.12"  // Updated runtime
  filename      = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/backend/lambda_function.zip"  // Update this path as needed

  source_code_hash = data.archive_file.lambda_handler_function.output_base64sha256

  environment {
    variables = {
      EMAIL_STORAGE_BUCKET = "${var.email_storage_bucket_name}"
    }
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.email_signup.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gw_rest_api
}