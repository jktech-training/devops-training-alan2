resource "aws_iam_role" "this" {

  name = var.role_name

  description = var.description

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "glue.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })


  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  ]


  inline_policy {
    name = "GlueDynamoDBReadPolicy"

    policy = jsonencode({
      Version = "2012-10-17"

      Statement = [
        {
          Sid = "ReadTransformationRules"

          Effect = "Allow"

          Action = [
            "dynamodb:Scan",
            "dynamodb:GetItem",
            "dynamodb:Query"
          ]

          Resource = var.dynamodb_table_arn
        }
      ]
    })
  }


  inline_policy {
    name = "GlueS3Access"

    policy = jsonencode({
      Version = "2012-10-17"

      Statement = [
        {
          Sid = "ListBuckets"

          Effect = "Allow"

          Action = [
            "s3:ListBucket"
          ]

          Resource = var.s3_bucket_arns
        },

        {
          Sid = "ReadWriteObjects"

          Effect = "Allow"

          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ]

          Resource = var.s3_object_arns
        }
      ]
    })
  }
}