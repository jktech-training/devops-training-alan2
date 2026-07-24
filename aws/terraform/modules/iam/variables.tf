variable "role_name" {
  type = string
}


variable "description" {
  type = string
}


variable "dynamodb_table_arn" {
  type = string
}


variable "s3_bucket_arns" {
  type = list(string)
}


variable "s3_object_arns" {
  type = list(string)
}

variable "managed_policy_arn" {
  description = "Managed policy ARN attached to IAM role"
  type        = string
}