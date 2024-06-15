variable "region" {
    type = string
    default = "us-east-1"
  
}
variable "profile" {
    type = string
    default = "devopsbravo" #update to your current aws profile
  
}

################S3###################

variable "website_name" {
    type = string
    description = "website bucket name "
    default = "chad-website-bucket-v2"
  
}

variable "email_bucket" {
    type = string
    description = "second bucket name"
    default = "chad-email-bucket-v2"
  
}
#################Lambda######################## 

variable "lambda_role_name" {
    type = string
    description = "lambda role name"
    default = "hackathon_lambda"
  
}
variable "lambda_policy_name" {
    type = string
    description = "lambda policy name"
    default = "hackathon_lambda_policies"
 
}

variable "lambda_function_name" {
    type = string
    description = "Lambda function name"
    default = "HackathonEmailSignup"
  
}

variable "lambda_function_file_path" {
    type = string
    description = "the file path for the lmabda function zip file"
    default = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/backend/lambda_function.zip" #update with your current path
    # default = "backend/lambda_function.zip"
  
}
variable "email_storage_bucket_name" {
    type = string
    description = "Enviroment variables value"
    default = "hackathon-email-storage"
  
}

##################API####################################

variable "api_gw_rest_API_name" {
    type = string
    description = "rest api name "
    default = "EmailSignupAPI"
  
}

