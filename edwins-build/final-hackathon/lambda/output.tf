# output "aws_lambda_function_arn" {
#     value = aws_lambda_function.email_signup.arn
# }
output "aws_lambda_function_arn" {
    value = aws_iam_role.lambda_role.arn
}
output "aws_lambda_function_invoke_arn" {
    value = aws_lambda_function.email_signup.invoke_arn
  
}