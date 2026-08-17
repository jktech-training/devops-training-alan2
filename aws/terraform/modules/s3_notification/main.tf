resource "aws_s3_bucket_notification" "this" {
  bucket = var.bucket_name

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }
}