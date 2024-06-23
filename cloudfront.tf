

resource "aws_cloudfront_origin_access_control" "distributed_imageserver" {
  name                              = "distributed_imageserver"
  description                       = "Allow Cloudfront access to the Distributed Image Server s3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_response_headers_policy" "custom_cors_with_preflight_and_allow_all_headers" {
  name = "cors-based-policy-with-allow-headers"

  cors_config {
    access_control_allow_credentials = false
    access_control_max_age_sec       = 600
    origin_override                  = true

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_methods {
      items = ["ALL"]
    }

    access_control_allow_origins {
      items = ["*"]
    }

    access_control_expose_headers {
      items = ["*"]
    }
  }
}

resource "aws_cloudfront_distribution" "distributed_imageserver" {
  origin {
    domain_name              = aws_s3_bucket.distributed_imageserver.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.distributed_imageserver.id
    origin_id                = var.s3_origin_id
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    response_headers_policy_id = aws_cloudfront_response_headers_policy.custom_cors_with_preflight_and_allow_all_headers.id
    viewer_protocol_policy     = "redirect-to-https"
    min_ttl                    = 0
    default_ttl                = 3600
    max_ttl                    = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_200"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
