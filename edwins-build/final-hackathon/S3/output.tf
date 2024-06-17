output "website_hackathon_bucket_arn" {
    value = aws_s3_bucket.website_hackathon.arn
  
}
output "email_bucket_arn" {
    value = aws_s3_bucket.email_hackathon.arn
}