# Distributed Image Server [WIP]

This repository contains Terraform configuration for simple distributed image server following the pattern from https://sre.google/classroom/imageserver/.

## What's done?

- S3 static website with JavaScript to view/upload/delete images (script taken from: https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/s3-example-photo-album-full.html)
- CloudFront distribution with S3 origin
- Amazon Cognito for unauthenticated users (testing purpose only)

## What's left?

- Amazon S3 object encryption using customer managed key 
- Amazon Cognito for authenticated users
- Lambda@Edge for validating JWT coming from Cognito
- RBAC for users in the S3 static website:
    - users can view all objects
    - user can modify only objects which they own
- CloudWatch monitoring for:
    - Lambda@Edge invocation errors
    - Lambda@Edge timeouts
    - CloudFront 4xx/5xx errors

## Considerations

- Even though project is something internal and more to get familiar with using many AWS services in correlation, I'm not sure I'll stay long with this simple JavaScript code for CRUD operations in S3. I considered using AWS Lambda which may be invoked when making actions on S3 objects OR more complex AWS SDK code.

- To enhance user experience, Cognito user pool should be extended with being able to log in via Google or Facebook accounts. It'll ease logging in.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_cloudfront_response_headers_policy.custom_cors_with_preflight_and_allow_all_headers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy) | resource |
| [aws_cognito_identity_pool.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool) | resource |
| [aws_cognito_identity_pool_roles_attachment.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_pool_roles_attachment) | resource |
| [aws_iam_policy.cognito_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.unauthenticated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_s3_bucket.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_cors_configuration.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_policy.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_website_configuration.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.synthetics_website](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [local_file.upload_images_javascript](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.distributed_imageserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.unauthenticated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |      
| [aws_kms_key.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | AWS S3 bucket name | `string` | n/a | yes |
| <a name="input_identity_pool_name"></a> [identity\_pool\_name](#input\_identity\_pool\_name) | AWS Cognito Identity Pool name | `string` | n/a | yes |
| <a name="input_s3_origin_id"></a> [s3\_origin\_id](#input\_s3\_origin\_id) | S3 Origin ID for CloudFront | `string` | n/a | yes |
| <a name="input_service"></a> [service](#input\_service) | Service name added to all resources | `string` | n/a | yes |

## Outputs

No outputs.