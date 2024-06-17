# creates s3 bucket
resource "aws_s3_bucket" "email_hackathon" {
    bucket = var.email_bucket 
}

# Identifies bucket Ownership

resource "aws_s3_bucket_ownership_controls" "email_hackathon_ownership" {
  bucket = aws_s3_bucket.email_hackathon.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "email_hackathon_access_block" {
  bucket = aws_s3_bucket.email_hackathon.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "email_hackathon_bucket_policy_attachemnent" {
  bucket = aws_s3_bucket.email_hackathon.id
  policy = data.aws_iam_policy_document.email_hackathon_bucket_policies.json
}
data "aws_iam_policy_document" "email_hackathon_bucket_policies" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources = [
      aws_s3_bucket.email_hackathon.arn,
      "${aws_s3_bucket.email_hackathon.arn}/*",
    ]
    condition {
      test = "ForAnyValue:StringEquals"
      variable = "aws:userid"
      values = ["${var.lambda_arn}"]
    }
  }
}