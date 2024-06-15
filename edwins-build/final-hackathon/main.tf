module "S3" {
    source = "./S3"
    website_name = var.website_name
    email_bucket = var.email_bucket
    lambda_arn = module.lambda.aws_lambda_function_arn
}
module "lambda" {
    source = "./lambda"
    lambda_role_name = var.lambda_role_name
    lambda_policy_name = var.lambda_policy_name
    email_bucket_arn = module.S3.email_bucket_arn
    full_email_bucket_arn = module.S3.email_bucket_arn
    lambda_function_name = var.lambda_function_name
    lambda_function_file_path = var.lambda_function_file_path
    email_storage_bucket_name = var.email_storage_bucket_name
    api_gw_rest_api = module.api.aws_api_gateway_rest_api
}

module "api" {
    source = "./API"
    api_gw_rest_API_name = var.api_gw_rest_API_name
    api_uri = module.lambda.aws_lambda_function_invoke_arn
}