resource "aws_s3_bucket" "website_hackathon" {
  bucket = "website-hackathon-bucket"
}

resource "aws_s3_bucket_website_configuration" "website_hackathon_config" {
  bucket = aws_s3_bucket.website_hackathon.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "website_hackathon_object" {
  bucket       = aws_s3_bucket.website_hackathon.id
  key          = "index.html"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "privacy_policy_html" {
  bucket       = aws_s3_bucket.website_hackathon.id
  key          = "privacy-policy.html"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/privacy-policy.html"
  content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.website_hackathon.id
  key          = "styles.css"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/styles.css"
  content_type = "text/css"
}

resource "aws_s3_object" "success_html" {
  bucket       = aws_s3_bucket.website_hackathon.id
  key          = "success.html"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/success.html"
  content_type = "text/html"
}

resource "aws_s3_object" "cd_tech_chattanooga_logo" {
  bucket       = aws_s3_bucket.website_hackathon.id
  key          = "assets/CD_Tech_Chattanooga_Logo.jpg"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/assets/CD_Tech_Chattanooga_Logo.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_object" "abstract_chattskyline" {
  bucket       = aws_s3_bucket.website_hackathon.id
  key          = "assets/abstract_chattskyline.jpg"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/assets/abstract_chattskyline.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_object" "chattskyline" {
  bucket       = aws_s3_bucket.website_hackathon.id
  key          = "assets/chattskyline.jpg"
  source       = "/Users/chadthompsonsmith/Desktop/Projects/app_in_dev/hack-chatt/frontend/assets/chattskyline.jpg"
  content_type = "image/jpeg"
}

resource "aws_s3_bucket_ownership_controls" "website_hackathon_ownership" {
  bucket = aws_s3_bucket.website_hackathon.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website_hackathon_access_block" {
  bucket = aws_s3_bucket.website_hackathon.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "website_hackathon_bucket_policies" {
  statement {
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.website_hackathon.arn}/*",
    ]
  }
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
    resources = [
      "${aws_s3_bucket.website_hackathon.arn}/*",
    ]
    condition {
      test = "ForAnyValue:StringEquals"
      variable = "aws:userid"
      values = ["${var.lambda_arn}"] # Ensure this variable is defined elsewhere in your Terraform configuration
    }
  }
}

resource "aws_s3_bucket_policy" "website_hackathon_bucket_policies_attachment" {
  bucket = aws_s3_bucket.website_hackathon.id
  policy = data.aws_iam_policy_document.website_hackathon_bucket_policies.json
}