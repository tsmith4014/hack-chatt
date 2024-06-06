variable "region" {
  default = "us-east-1"
}

variable "lambda_function_name" {
  default = "HackathonEmailSignup"
}

variable "website_bucket_name" {
  default = "hackathon-website-bucket"
}

variable "email_storage_bucket_name" {
  default = "hackathon-email-storage"
}

variable "lambda_s3_key" {
  default = "lambda_function.zip"
}
