variable "service" {
  type        = string
  description = "Service name added to all resources"
}

variable "bucket_name" {
  type        = string
  description = "AWS S3 bucket name"
}

variable "s3_origin_id" {
  type        = string
  description = "S3 Origin ID for CloudFront"
}

variable "identity_pool_name" {
  type        = string
  description = "AWS Cognito Identity Pool name"
}