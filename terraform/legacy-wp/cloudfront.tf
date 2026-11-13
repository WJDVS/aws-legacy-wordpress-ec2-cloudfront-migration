resource "aws_cloudfront_distribution" "cdn" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "Legacy WordPress CDN - legacy-wp-dev-cdn"
  price_class     = "PriceClass_100"

  origin {
    domain_name = "ec2-3-208-23-126.compute-1.amazonaws.com"
    origin_id   = "EC2Origin-legacy-wp-dev-ec2"

    custom_origin_config {
      http_port              = 8000 # <--- Updated from 80 to 8000
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Bypass cache for WordPress Admin & Login
  ordered_cache_behavior {
    path_pattern     = "/wp-admin/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "EC2Origin-legacy-wp-dev-ec2"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  ordered_cache_behavior {
    path_pattern     = "/wp-login.php"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "EC2Origin-legacy-wp-dev-ec2"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  # Default behavior for general traffic and static assets
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "EC2Origin-legacy-wp-dev-ec2"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Project     = "legacy-wp"
    Environment = "dev"
    ManagedBy   = "terraform"
    Name        = "legacy-wp-dev-cdn"
  }
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cdn.domain_name
}