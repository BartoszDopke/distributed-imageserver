# temporary solution for unauthenticated users to make AWS SDK inside s3Upload.js working
# it will be replaced by Cognito for authenticated users enhanced with Lambda@Edge

resource "aws_iam_policy" "cognito_permissions" {
  name = "cognito-permissions-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowUnauthenticatedUsers"
        Effect   = "Allow"
        Action   = ["cognito-identity:GetCredentialsForIdentity"]
        Resource = "*"
      },
      {
        Sid      = "AllowS3"
        Effect   = "Allow"
        Action   = ["s3:DeleteObject", "s3:GetObject", "s3:ListBucket", "s3:PutObject", "s3:PutObjectAcl"]
        Resource = [aws_s3_bucket.distributed_imageserver.arn, "${aws_s3_bucket.distributed_imageserver.arn}/*"]
      }
    ]
  })
}

data "aws_iam_policy_document" "unauthenticated" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values   = [aws_cognito_identity_pool.distributed_imageserver.id]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values   = ["unauthenticated"]
    }
  }
}

resource "aws_iam_role" "unauthenticated" {
  name                = "cognito_unauthenticated"
  managed_policy_arns = [aws_iam_policy.cognito_permissions.arn]
  assume_role_policy  = data.aws_iam_policy_document.unauthenticated.json
}

resource "aws_cognito_identity_pool" "distributed_imageserver" {
  identity_pool_name               = var.identity_pool_name
  allow_unauthenticated_identities = true # temporary while not having Lambda@Edge for authentication and Cognito User Pool in place
  allow_classic_flow               = false
}

resource "aws_cognito_identity_pool_roles_attachment" "distributed_imageserver" {
  identity_pool_id = aws_cognito_identity_pool.distributed_imageserver.id

  roles = {
    "unauthenticated" = aws_iam_role.unauthenticated.arn
  }
}