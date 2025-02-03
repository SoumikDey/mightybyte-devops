locals {
  bucket = "${var.resource_tags["environ"]}-${var.frontend_bucket_name}"
}

data "aws_cloudfront_cache_policy" "CachingOptimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "COPSCustomOrigin" {
  name = "Managed-CORS-CustomOrigin"
}
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${local.bucket}-access-control"
  description                       = "${local.bucket}-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = "${local.bucket}.s3.${var.aws_region}.amazonaws.com"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.bucket
  }


  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${local.bucket}-origin"
  default_root_object = "index.html"


  #   aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    # allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    allowed_methods = ["GET", "HEAD"]

    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.bucket
    cache_policy_id  = data.aws_cloudfront_cache_policy.CachingOptimized.id

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.COPSCustomOrigin.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = var.resource_tags

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
