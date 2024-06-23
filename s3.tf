data "aws_iam_policy_document" "distributed_imageserver" {
  statement {
    sid       = "AllowCloudFrontServicePrincipalReadOnly"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.distributed_imageserver.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.distributed_imageserver.arn]
    }
  }
}

resource "aws_s3_bucket" "distributed_imageserver" {
  bucket        = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "distributed_imageserver" {
  bucket                  = aws_s3_bucket.distributed_imageserver.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "distributed_imageserver" {
  bucket = aws_s3_bucket.distributed_imageserver.id
  policy = data.aws_iam_policy_document.distributed_imageserver.json
}

resource "aws_s3_bucket_cors_configuration" "distributed_imageserver" {
  bucket = aws_s3_bucket.distributed_imageserver.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["HEAD", "GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
  }
}

resource "aws_s3_bucket_website_configuration" "distributed_imageserver" {
  bucket = aws_s3_bucket.distributed_imageserver.id

  index_document {
    suffix = "index.html"
  }
}

resource "local_file" "upload_images_javascript" {
  filename = "content/s3Upload.js"
  content = templatefile("templates/s3Upload.js.tftpl", {
    albumBucketName = aws_s3_bucket.distributed_imageserver.id
    bucketRegion    = data.aws_region.current.name
    IdentityPoolId  = aws_cognito_identity_pool.distributed_imageserver.id
  })
}

resource "aws_s3_object" "synthetics_website" {
  depends_on = [local_file.upload_images_javascript]
  for_each   = fileset(path.module, "content/**/*.{html,css,js}")

  bucket       = aws_s3_bucket.distributed_imageserver.id
  key          = replace(each.value, "/^content//", "")
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  etag         = filemd5(each.value)
}