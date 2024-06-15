variable "lambda_role_name" {
    type = string
    description = "lambda role name"
  
}
variable "lambda_policy_name" {
    type = string
    description = "lambda policy name"
 
}

variable "email_bucket_arn" {
    type = string
    description = "regualr path of the bucket"
  
}
variable "full_email_bucket_arn" {
    type = string
    description = "full bucket arn path"
  
}
variable "lambda_function_name" {
    type = string
    description = "Lambda function name"
  
}
variable "lambda_function_file_path" {
    type = string
    description = "the file path for the lmabda function zip file"
  
}

variable "email_storage_bucket_name" {
    type = string
    description = "Enviroment variables value"
  
}
variable "api_gw_rest_api" {
    type = string
    description = "attaching api gw arn to lambda"
  
}