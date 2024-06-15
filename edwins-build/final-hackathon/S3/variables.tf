variable "website_name" {
    type = string
    description = "website bucket name "
  
}

variable "email_bucket" {
    type = string
    description = "second bucket name"
  
}
variable "lambda_arn" {
    type = string
    description = "adding lambda arn for s3 bucket policy condition"
  
}


