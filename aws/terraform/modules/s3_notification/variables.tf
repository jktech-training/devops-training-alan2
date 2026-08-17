variable "bucket_name" {
  description = "S3 bucket that receives the CSV files"
  type        = string
}

variable "lambda_function_arn" {
  description = "Lambda function ARN triggered by S3"
  type        = string
}