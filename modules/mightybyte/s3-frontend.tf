module "s3-frontend" {
  source = "../s3-bucket"
  bucket = "${var.resource_tags["environ"]}-${var.frontend_bucket_name}"
  versioning = {
    enabled = false
  }
  block_public_acls        = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
  block_public_policy      = true
  attach_policy            = false
  policy                   = ""
  control_object_ownership = false
  object_ownership         = "BucketOwnerEnforced"
  tags                     = var.resource_tags

}

resource "aws_s3_bucket_policy" "cloudfront_s3_bucket_policy" {
  bucket = "${var.resource_tags["environ"]}-${var.frontend_bucket_name}"
  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3-frontend.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}
